# frozen_string_literal: true

module Tests
  # RSpec helpers and utilities
  module RSpecHelpers
    base_dir = File.expand_path('./rspec_helpers', __dir__)
    autoload :AuthenticationHelpers, File.join(base_dir, 'authentication_helpers')
    autoload :IsExpectedOnCall, File.join(base_dir, 'is_expected_on_call')
    autoload :RespondWith, File.join(base_dir, 'respond_with')
    autoload :RespondWithJSON, File.join(base_dir, 'respond_with_json')
    autoload :Causes, File.join(base_dir, 'causes')
    autoload :JSONApi, File.join(base_dir, 'json_api')
    autoload :RouteTo, File.join(base_dir, 'route_to')

    def self.included(base)
      [AuthenticationHelpers, IsExpectedOnCall, RespondWith, RespondWithJSON, Causes,
       JSONApi].each do |mod|
        base.include mod
      end
    end
  end
end
