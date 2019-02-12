# frozen_string_literal: true

Dir[File.expand_path('strategies/*', __dir__)].each { |f| require f }

module Authentication
  # top level namespace for authentication strategies
  module Strategies
  end
end
