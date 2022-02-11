source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.4'

gem 'blueprinter', '~> 0.25.3'
gem 'bootsnap', '~> 1.9.1', require: false
gem 'devise', '~> 4.8.0'
gem 'devise_token_auth', '~> 1.2.0'
gem 'dry-validation', '~> 1.7.0'
gem 'jbuilder', '~> 2.11.2'
gem 'newrelic_rpm', '~> 8.1.0'
gem 'pg', '~> 1.2.3'
gem 'puma', '~> 5.6.2'
gem 'rack-cors'
gem 'rails', '~> 6.1.4'
gem 'sass-rails', '~> 6.0'
gem 'sentry-rails', '~> 4.7.3'
gem 'sentry-ruby', '~> 4.7.3'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'dotenv-rails', '~> 2.7.6'
  gem 'pry-byebug', '~> 3.9.0'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rspec-rails', '~> 5.0.2'
end

group :development do
  gem 'listen', '~> 3.7.0'
  gem 'rubocop', '~> 1.22.3', require: false
  gem 'rubocop-performance', '~> 1.12.0', require: false
  gem 'rubocop-rails', '~> 2.12.4', require: false
  gem 'rubocop-rspec', '~> 2.6.0', require: false
  gem 'web-console', '~> 4.1.0'
end

group :test do
  gem 'factory_bot_rails', '~> 6.2.0'
  gem 'faker', '~> 2.19.0'
end
