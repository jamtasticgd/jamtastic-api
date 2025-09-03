# frozen_string_literal: true

# itch.io OAuth Configuration
# 
# To configure itch.io OAuth:
# 1. Register your application at https://itch.io/user/settings/oauth
# 2. Copy .env-example to .env and set the following environment variables:
#    - ITCHIO_CLIENT_ID: Your itch.io OAuth application client ID
#    - ITCHIO_CLIENT_SECRET: Your itch.io OAuth application client secret (if needed)
#
# Example environment variables:
# ITCHIO_CLIENT_ID=your_client_id_here
# ITCHIO_CLIENT_SECRET=your_client_secret_here

Rails.application.configure do
  config.itchio_oauth = ActiveSupport::OrderedOptions.new
  
  # Client ID from itch.io OAuth application
  config.itchio_oauth.client_id = ENV['ITCHIO_CLIENT_ID']
  
  # Client secret (if needed for future API calls)
  config.itchio_oauth.client_secret = ENV['ITCHIO_CLIENT_SECRET']
  
  # OAuth scopes
  config.itchio_oauth.scopes = ['profile:me']
  
  # API base URL (configurable via environment)
  config.itchio_oauth.api_base_url = ENV.fetch('ITCHIO_API_BASE_URL', 'https://itch.io/api/1')
  
  # OAuth authorization URL (configurable via environment)
  config.itchio_oauth.authorization_url = ENV.fetch('ITCHIO_OAUTH_URL', 'https://itch.io/user/oauth')
  
  # Frontend URL for redirects (used in OAuth callback)
  config.itchio_oauth.frontend_url = ENV.fetch('FRONTEND_URL', 'http://localhost:3000')
  
  # API URL for OAuth callbacks
  config.itchio_oauth.api_url = ENV.fetch('API_URL', 'http://localhost:3001')
  
  # Validate configuration
  if Rails.env.production? && config.itchio_oauth.client_id.blank?
    Rails.logger.warn 'ITCHIO_CLIENT_ID is not set. itch.io OAuth will not work in production.'
  end
  
  # Log configuration status
  if config.itchio_oauth.client_id.present?
    Rails.logger.info "itch.io OAuth configured with client ID: #{config.itchio_oauth.client_id[0..8]}..."
  else
    Rails.logger.warn 'itch.io OAuth not configured. Set ITCHIO_CLIENT_ID environment variable.'
  end
end
