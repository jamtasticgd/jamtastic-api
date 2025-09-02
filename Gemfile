source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.5'

gem 'blueprinter', '~> 1.1'
gem 'bootsnap', '~> 1.16', require: false
gem 'devise', '~> 4.9'
gem 'devise_token_auth', '~> 1.2'
gem 'dry-validation', '~> 1.10'
gem 'newrelic_rpm', '~> 9.2'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.3'
gem 'rack-cors'
gem 'rails', '~> 8.0'
gem 'sentry-rails', '~> 5.9'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'dotenv-rails', '~> 3.1'
  gem 'pry-rails', '~> 0.3'
  gem 'rspec-rails', '~> 8.0'
end

group :development do
  gem 'dockerfile-rails', '>= 1.4'
  gem 'listen', '~> 3.8'
  gem 'rubocop', '~> 1.51', require: false
  gem 'rubocop-performance', '~> 1.18', require: false
  gem 'rubocop-rails', '~> 2.19', require: false
  gem 'rubocop-rspec', '~> 3.7', require: false
  gem 'web-console', '~> 4.2'
end

group :test do
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 3.2'
  gem 'simplecov', '~> 0.22', require: false
end
