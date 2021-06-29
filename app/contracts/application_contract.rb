class ApplicationContract < Dry::Validation::Contract
  config.messages.backend = :i18n
  config.messages.default_locale = 'pt-BR'
  config.messages.load_paths << 'config/locales/dry-errors.yml'
end
