# Be sure to restart your server when you modify this file.

Sentry.init do |config|
  config.enabled_environments = ['production', 'staging']

  filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)

  config.before_send = lambda do |event, hint|
    filter.filter(event.to_hash)
  end
end
