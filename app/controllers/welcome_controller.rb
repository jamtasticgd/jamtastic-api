class WelcomeController < ActionController::API
  def index
    render json: {
      status: 'healthy',
      timestamp: Time.current.iso8601,
      environment: Rails.env,
      version: '1.0.0'
    }
  end
end
