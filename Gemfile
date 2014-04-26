ruby '2.1.1'
source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.0.1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
# gem 'coffee-rails', '~> 4.0.0'

# Use foundation
gem "compass-rails"
gem 'zurb-foundation', '~> 4.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do
  # Use passenger (https://github.com/phusion/passenger-ruby-heroku-demo)
  gem "passenger"

  # Enable gzip on heroku
  gem 'heroku-deflater', :group => :production
end

group :dev do
  # Use unicorn as the app server
  gem 'unicorn'

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  # A static analysis security vulnerability scanner for Ruby on Rails applications
  gem 'brakeman'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

group :test do
  gem 'simplecov', :require => false
  gem 'webmock'
end

# Read .env file for console and rake
gem 'dotenv-rails', :groups => [:development, :test]

gem 'awesome_nested_set', '~> 3.0.0.rc.2'
# http://www.rubygeocoder.com/
gem 'geocoder'
gem 'forecast_io'
gem 'wunderground'
# Use for caching api calls
gem 'cache_method'
# A unit handling library for ruby
gem 'ruby-units'

# Use safe yaml parsing
gem 'safe_yaml'
