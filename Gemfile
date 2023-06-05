source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Rails Basics
gem "rails", "~> 7.0.5"
gem "sprockets-rails"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "bootsnap", require: false

# Webserver
gem "puma", "~> 6.3"

# Database
gem "pg", "~> 1.5"

# Authentication
gem 'devise'

# Background Job Handling
gem 'sidekiq'

# Redis adapter to run Action Cable in production
# And for sidekiq background jobs
gem "redis", "~> 5.0"

# Push Notifications
gem 'noticed'
gem 'googleauth'

# Styling
gem "cssbundling-rails", "~> 1.1"

# Deployment
gem 'mina'

# Error monitoring
gem 'honeybadger'

# Performance monitoring
gem 'skylight'

# Other
gem 'faker'
gem 'rqrcode'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'pry'
  gem 'pry-rails'
end

group :development do
  gem "web-console"
  gem "rack-mini-profiler"
  gem 'better_errors'
  gem 'sassc' # better_errors dependency. Can be removed when PR is merged: https://github.com/BetterErrors/better_errors/pull/515

  gem 'binding_of_caller'
  gem 'solargraph'
  gem 'remote_database_importer'
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
