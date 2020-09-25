module Api
  module Users
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      before_action :configure_permitted_parameters, if: :devise_controller?

      protected

      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: %i[name telegram])
      end
    end
  end
end
