Rails.application.config.middleware.insert_before(0, Rack::Cors) do
  allow do
    origins '*'
    resource '*',
      expose: %i[access-token client token-type uid],
      headers: :any,
      methods: %i[get post patch put]
  end
end
