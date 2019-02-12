# frozen_string_literal: true

module API
  # Helper class to setup API configuration
  class Configuration
    include ActiveSupport::Configurable

    def self.api_base_class
      config.api_base_class.to_s.constantize
    end
  end
end
