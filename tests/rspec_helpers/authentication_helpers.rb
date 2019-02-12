# frozen_string_literal: true

module Tests
  module RSpecHelpers
    # shared example definition
    module AuthenticationHelpers
      include Warden::Test::Helpers

      def self.included(_base)
        Authentication.config.scopes.each do |scope, _config|
          define_method("login_with_#{scope}") do
            ExampleConfigurator.new(self, scope).setup(FactoryBot.create(scope))
          end
        end
      end

      def ensure_not_logged_in
        class_eval do
          before { Warden.test_reset! }
        end
      end

      # configure an example so that given user is authenticated
      ExampleConfigurator = Struct.new(:example, :scope) do
        def setup(user)
          example.login_as(user, scope: scope)
          example_class.after { Warden.test_reset! }
          example_class.let("current_#{scope}") { user }
        end

        private

        def example_class
          example.singleton_class
        end
      end
    end
  end
end
