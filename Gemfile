source "https://rubygems.org"

gem "rails", "~> 8.0.0"
gem "bootsnap", require: false
gem "httparty"
gem "kamal", require: false
gem "importmap-rails"
gem "pagy", ">= 9.3.0"
gem "pg", "~> 1.5", ">= 1.5.6"
gem "propshaft"
gem "puma", ">= 5.0"
gem "sidekiq", ">= 7.0.0"
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "thruster", require: false
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "bcrypt", "~> 3.1.7"
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem "brakeman", require: false
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails", ">= 7.1.1"
end

group :development do
  gem "letter_opener"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "database_cleaner-active_record"
  gem "factory_bot_rails", "~> 6.4"
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 6.0"
  gem "webmock"
end
