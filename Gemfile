source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.4'

gem 'blueprinter', '~> 0.25.3'
gem 'bootsnap', '~> 1.16.0', require: false
gem 'devise', '~> 4.9.2'
gem 'devise_token_auth', '~> 1.2.0'
gem 'dry-validation', '~> 1.10.0'
gem 'jbuilder', '~> 2.11.2'
gem 'newrelic_rpm', '~> 9.2.2'
gem 'pg', '~> 1.5.3'
gem 'puma', '~> 6.3.0'
gem 'rack-cors'
gem 'rails', '~> 6.1.4'
gem 'sass-rails', '~> 6.0'
gem 'sentry-rails', '~> 5.9.0'
gem 'sentry-ruby', '~> 5.9.0'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'dotenv-rails', '~> 2.8.1'
  gem 'pry-byebug', '~> 3.10.1'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rspec-rails', '~> 6.0.3'
end

group :development do
  gem 'listen', '~> 3.8.0'
  gem 'rubocop', '~> 1.51.0', require: false
  gem 'rubocop-performance', '~> 1.18.0', require: false
  gem 'rubocop-rails', '~> 2.19.1', require: false
  gem 'rubocop-rspec', '~> 2.22.0', require: false
  gem 'web-console', '~> 4.2.0'
end

group :test do
  gem 'factory_bot_rails', '~> 6.2.0'
  gem 'faker', '~> 3.2.0'
end
