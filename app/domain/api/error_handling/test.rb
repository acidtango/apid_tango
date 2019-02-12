# frozen_string_literal: true

module API
  module ErrorHandling
    # error handling configuration
    module Test
      class << self
        attr_accessor :enabled

        def enable
          self.enabled = true
        end

        def disable
          self.enabled = false
        end
      end

      enable

      # override rescue methods
      module ErrorHandlingOverride
        def rescue_custom_error(*args)
          return super if API::ErrorHandling::Test.enabled

          raise
        end

        def rescue_standard_error(*args)
          return super if API::ErrorHandling::Test.enabled

          raise
        end

        def rescue_validation_error(*args)
          return super if API::ErrorHandling::Test.enabled

          raise
        end
      end
    end
  end
end

API::Configuration.api_base_class.prepend(API::ErrorHandling::Test::ErrorHandlingOverride)
