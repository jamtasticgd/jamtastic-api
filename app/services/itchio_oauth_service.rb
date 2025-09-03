# frozen_string_literal: true

class ItchioOauthService

  class << self
    def authorization_url(client_id:, redirect_uri:, state: nil)
      params = {
        client_id: client_id,
        scope: 'profile:me',
        redirect_uri: redirect_uri
      }
      params[:state] = state if state.present?

      "#{Rails.application.config.itchio_oauth.authorization_url}?#{params.to_query}"
    end

    def exchange_code_for_token(access_token)
      user_info = fetch_user_info(access_token)
      return nil unless user_info

      {
        itchio_id: user_info['id'].to_s,
        itchio_username: user_info['username'],
        itchio_access_token: access_token
      }
    end

    def fetch_user_info(access_token)
      response = make_api_request('/me', access_token)
      return nil unless response&.success?

      JSON.parse(response.body)
    rescue JSON::ParserError, StandardError => e
      Rails.logger.error "Failed to fetch itch.io user info: #{e.message}"
      nil
    end

    def validate_access_token(access_token)
      return false if access_token.blank?

      response = make_api_request('/credentials/info', access_token)
      response&.success?
    end

    private

    def make_api_request(endpoint, access_token)
      uri = URI("#{Rails.application.config.itchio_oauth.api_base_url}#{endpoint}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri)
      request['Authorization'] = "Bearer #{access_token}"
      request['User-Agent'] = 'Jamtastic-API/1.0'

      http.request(request)
    rescue StandardError => e
      Rails.logger.error "itch.io API request failed: #{e.message}"
      nil
    end
  end
end
