class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :set_sentry_context

  private

  def set_sentry_context
    Sentry.set_user(id: session[:current_user_id])
    Sentry.set_extras(params: params.to_unsafe_h, url: request.url)
  end

  def validate_params(contract_class)
    contract_class.new.call(params.permit!.to_h)
  end
end
