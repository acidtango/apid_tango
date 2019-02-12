# frozen_string_literal: true

module RSpec
  module Helpers
    # Setup methods for simulating authentication events in tests
    module Authentication
      include Warden::Test::Helpers

      def login_with_user
        login_with_factory(:user, :admin)
      end

      def login_with_supplier
        login_with_factory(:supplier, :admin)
      end

      def login_with_client
        login_with_factory(:client, :admin)
      end

      def login_with_operations
        login_with_factory(:operations, :admin)
      end

      private

      def login_with_factory(factory, scope)
        configurator = Tests::RSpecHelpers::AuthenticationHelpers::ExampleConfigurator
        configurator.new(self, scope).setup(FactoryBot.create(factory))
      end
    end
  end
end

RSpec.configure do |config|
  config.include RSpec::Helpers::Authentication
end
