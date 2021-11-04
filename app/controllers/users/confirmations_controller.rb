module Users
  class ConfirmationsController < DeviseTokenAuth::ConfirmationsController
    rescue_from ActionController::RoutingError, with: -> { head :not_found }

    def show
      @resource = resource_class.confirm_by_token(resource_params[:confirmation_token])

      raise ActionController::RoutingError, 'Not Found' if @resource.errors.any?

      render json: {
        success: true,
        message: I18n.t('devise_token_auth.confirmations.confirmed')
      }
    end
  end
end
