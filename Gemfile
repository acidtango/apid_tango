# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0.beta1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# allow CORS
gem 'rack-cors', require: 'rack/cors'
# Resource-Oriented Architectures in Ruby
gem 'roar'
# Provides support for JSON API
gem 'roar-jsonapi', require: 'roar/json/json_api', git: 'https://github.com/nico-acidtango/roar-jsonapi'
# Kaminari core
gem 'kaminari-core'
# Paginator
gem 'kaminari-activerecord'
# Less noisy logging
gem 'lograge'
# api pagination
gem 'api-pagination'
# A common interface to multiple JSON libraries
gem 'multi_json'
# Authentication for rack applications
gem 'warden', '~> 1.2', '>= 1.2.8'
# Secure hash algorithm for hashing passwords
gem 'bcrypt', '~> 3.1', '>= 3.1.12'
gem 'openssl'

# JSON Web Token
gem 'jwt'

# http client
gem 'faraday'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  # irb alternative
  gem 'pry'
  gem 'pry-rails'
  # Shim to load environment variables from .env into ENV in development
  gem 'dotenv-rails'
end

group :test do
  # testing with rspec
  gem 'rspec-rails', '~> 3.5'
  # express expected outcomes on collections of an object in an example
  gem 'rspec-collection_matchers'
  # one liners for common rails functionality
  gem 'shoulda-matchers', '~> 3.1'
  # test data generator
  gem 'factory_bot'
  # Code coverage
  gem 'simplecov', require: false
  # Library for stubbing and setting expectations on HTTP requests in Ruby
  gem 'webmock'
  # time travel in tests
  gem 'timecop'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background.
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Access an IRB console on exception pages or by using <%= console %>
  # anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # Ruby static code analyzer
  gem 'rubocop', '~> 0.63.1', require: false
  # Rubocop RSpec-specific analysis
  gem 'rubocop-rspec'
  # Manage and configure Git hooks
  gem 'overcommit'
  # Code smells report
  gem 'reek'
  # benchmarking
  gem 'derailed_benchmarks'
  # profiling methods
  gem 'stackprof'
  # tracing garbage collection
  gem 'gc_tracer'
end
