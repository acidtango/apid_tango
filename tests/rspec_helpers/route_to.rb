# frozen_string_literal: true

module Tests
  module RSpecHelpers
    # default route to
    module RouteTo
      class <<self
        attr_accessor :defaults
      end

      def self.included(base)
        base.prepend RouteToMatcherWithDefaults
      end

      # overrides route_to, to include format: json
      module RouteToMatcherWithDefaults
        # :reek:FeatureEnvy :reek:DuplicateMethodCall
        def route_to(*args)
          defaults = (RouteTo.defaults || {}).dup
          if args[0].is_a? Hash
            args[0] = defaults.merge(args[0])
          else
            args[1] = { format: 'json' }.merge(args[1] || {})
          end
          super(*args)
        end
      end
    end
  end
end
