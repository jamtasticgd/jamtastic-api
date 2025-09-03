# frozen_string_literal: true

module Users
  class ItchioOauthController < ApplicationController
    before_action :authenticate_user!, only: [:link_account]
    skip_before_action :verify_authenticity_token, only: [:callback]

    # GET /users/itchio_oauth/authorize
    def authorize
      client_id = Rails.application.config.itchio_oauth.client_id
      
      if client_id.blank?
        render json: { error: 'itch.io OAuth is not configured' }, status: :service_unavailable
        return
      end
      
      redirect_uri = "#{Rails.application.config.itchio_oauth.api_url}/users/itchio_oauth/callback"
      state = generate_state_token

      # Store state in session for validation
      session[:itchio_oauth_state] = state

      authorization_url = ItchioOauthService.authorization_url(
        client_id: client_id,
        redirect_uri: redirect_uri,
        state: state
      )

      redirect_to authorization_url, allow_other_host: true
    end

    # GET /users/itchio_oauth/callback
    def callback
      # For GET requests, render the callback page
      if request.get?
        render :callback
        return
      end

      # For POST requests, handle the OAuth callback
      access_token = params[:access_token]
      state = params[:state]

      # Validate state parameter
      unless state == session[:itchio_oauth_state]
        render json: { error: 'Invalid state parameter' }, status: :bad_request
        return
      end

      # Clear state from session
      session.delete(:itchio_oauth_state)

      if access_token.blank?
        render json: { error: 'Access token not provided' }, status: :bad_request
        return
      end

      # Exchange access token for user info
      itchio_data = ItchioOauthService.exchange_code_for_token(access_token)
      unless itchio_data
        render json: { error: 'Failed to fetch itch.io user data' }, status: :unprocessable_entity
        return
      end

      # Handle authentication or account linking
      if user_signed_in?
        link_itchio_account(itchio_data)
      else
        authenticate_with_itchio(itchio_data)
      end
    end

    # POST /users/itchio_oauth/link_account
    def link_account
      access_token = params[:access_token]

      if access_token.blank?
        render json: { error: 'Access token is required' }, status: :bad_request
        return
      end

      # Validate access token
      unless ItchioOauthService.validate_access_token(access_token)
        render json: { error: 'Invalid access token' }, status: :unauthorized
        return
      end

      # Exchange access token for user info
      itchio_data = ItchioOauthService.exchange_code_for_token(access_token)
      unless itchio_data
        render json: { error: 'Failed to fetch itch.io user data' }, status: :unprocessable_entity
        return
      end

      link_itchio_account(itchio_data)
    end

    # DELETE /users/itchio_oauth/unlink_account
    def unlink_account
      current_user.update!(
        itchio_id: nil,
        itchio_username: nil,
        itchio_access_token: nil
      )

      render json: { message: 'itch.io account unlinked successfully' }
    end

    private

    def authenticate_with_itchio(itchio_data)
      # Try to find existing user by itch.io ID
      user = User.find_by(itchio_id: itchio_data[:itchio_id])

      if user
        # Update existing user's itch.io data
        user.update!(itchio_data)
      else
        # Create new user with itch.io data
        user = User.create!(
          email: "#{itchio_data[:itchio_username]}@itchio.local",
          password: Devise.friendly_token[0, 20],
          name: itchio_data[:itchio_username],
          provider: 'itchio',
          uid: itchio_data[:itchio_id],
          confirmed_at: Time.current,
          **itchio_data
        )
      end

      # Generate auth token
      auth_token = user.create_new_auth_token

      render json: {
        data: {
          user: ItchioOauthSerializer.render_as_hash(user),
          tokens: auth_token
        }
      }
    end

    def link_itchio_account(itchio_data)
      # Check if itch.io account is already linked to another user
      existing_user = User.where.not(id: current_user.id).find_by(itchio_id: itchio_data[:itchio_id])
      if existing_user
        render json: { error: 'This itch.io account is already linked to another user' }, status: :conflict
        return
      end

      # Update current user with itch.io data
      current_user.update!(itchio_data)

      render json: {
        message: 'itch.io account linked successfully',
        user: ItchioOauthSerializer.render_as_hash(current_user)
      }
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    def generate_state_token
      SecureRandom.urlsafe_base64(32)
    end
  end
end
