class ApplicationController < ActionController::API
  include Contractable
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :set_sentry_context
  before_action :validate_contract

  rescue_from ActiveRecord::RecordNotFound, with: -> { head :not_found }
  rescue_from InvalidContractError do
    render(json: Contracts::ErrorsSerializer.render(contract_result), status: :unprocessable_entity)
  end

  def set_sentry_context
    Sentry.set_user(id: session[:current_user_id])
    Sentry.set_extras(params: params.to_unsafe_h, url: request.url)
  end
end
