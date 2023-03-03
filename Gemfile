source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Rails Basics
gem "rails", "~> 7.0.4"
gem "sprockets-rails"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "bootsnap", require: false

# Webserver
gem "puma", "~> 6.1"

# Database
gem "pg", "~> 1.4"

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
gem "tailwindcss-rails", "~> 2.0"
gem "cssbundling-rails", "~> 1.1"

# Deployment
gem 'mina'

# Other
gem 'faker'

# Monitoring
gem 'honeybadger'

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
  gem 'binding_of_caller'
  gem 'solargraph'
  gem 'remote_database_importer'
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
