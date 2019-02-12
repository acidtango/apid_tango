# frozen_string_literal: true

module RSpec
  module Examples
    # helper module
    module Helpers
      def self.included(base)
        base.extend ClassMethods
        base.include InstanceMethods
      end

      # example helper method
      module ClassMethods
        def instantiate_before(*args)
          before do
            args.each do |variable|
              public_send(variable)
            end
          end
        end
      end

      # test helpers
      module InstanceMethods
        # :reek:UtilityFunction
        def at(time, &block)
          Timecop.freeze(time, &block)
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include RSpec::Examples::Helpers
end
