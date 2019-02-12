# frozen_string_literal: true

module Authentication
  module Helpers
    # Helpers to use with grape endpoints
    module RailsHelpers
      def self.included(base)
        base.include InstanceMethods
        Authentication.config.scopes.each do |scope, _config|
          define_helpers(base, scope)
        end
      end

      def self.define_helpers(base, scope)
        base.class_eval <<-METHODS, __FILE__, __LINE__ + 1
          def authenticate_#{scope}!(opts={})
            warden.authenticate!(scope: :#{scope})
          end

          def current_#{scope}
            warden.user(scope: :#{scope})
          end

          if respond_to?(:helper_method)
            helper_method "current_#{scope}"
          end
        METHODS
      end

      # Helpers implementation
      module InstanceMethods
        def warden
          @warden ||= request.env['warden']
        end
      end
    end
  end
end
