module Api
  class ApplicationController < ::ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken

    skip_before_action :verify_authenticity_token, if: :devise_controller?

    private

    def validate_params(contract_class)
      contract_class.new.call(params.permit!.to_h)
    end
  end
end
