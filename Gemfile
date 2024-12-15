source "https://rubygems.org"

# Rails Basics
gem "rails", "~> 8.0"
gem "sprockets-rails"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "bootsnap", require: false
gem "sassc"

# Webserver
gem "puma"

# Database
gem "pg", "~> 1.5"

# Authentication
gem "devise"

# Background Job Handling
gem "sidekiq"

# Redis adapter to run Action Cable in production
# And for sidekiq background jobs
gem "redis"

# Push Notifications
gem "noticed", "~> 1.6.3"
gem "googleauth"

# Styling
gem "cssbundling-rails", "~> 1.2"

# Deployment
gem "kamal", require: false
gem "thruster", require: false

# Monitoring
gem "honeybadger"

# Performance monitoring
gem "skylight"

# Cron jobs
gem "whenever"

# Other
gem "faker"
gem "rqrcode"
gem "standard", group: [:development, :test]

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "pry"
  gem "pry-rails"
end

group :development do
  gem "web-console"
  gem "rack-mini-profiler"
  gem "better_errors"

  gem "binding_of_caller"
  gem "solargraph"
  gem "remote_database_importer"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
