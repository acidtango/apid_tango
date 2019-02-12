# frozen_string_literal: true

module RSpec
  module Helpers
    # helper method to activate/deactivate error handling
    module ErrorHandling
      def disable_error_handling
        class_eval do
          before { API::ErrorHandling::Test.disable }
        end
      end

      def enable_error_handling
        class_eval do
          before { API::ErrorHandling::Test.enable }
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include RSpec::Helpers::ErrorHandling
  config.before(:each, type: :request) do
    API::ErrorHandling::Test.disable
  end
end
