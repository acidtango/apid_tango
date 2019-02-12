# frozen_string_literal: true

module Tests
  module RSpecHelpers
    # calls subject and then test on affected object
    module Causes
      def causes(obj = nil)
        subject
        obj = yield if block_given?
        expect(obj)
      end
    end
  end
end
