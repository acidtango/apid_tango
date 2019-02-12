# frozen_string_literal: true

module Tests
  module RSpecHelpers
    # Adds a helper method to refer to calls on subject
    module RespondWith
      def respond_with(status)
        RespondWithMatcher.new(self, status)
      end

      # Matches againts the response object the http status
      class RespondWithMatcher < SimpleDelegator
        attr_reader :response

        def initialize(base, status)
          @response = base.response
          super base.have_http_status(status)
        end

        def matches?(_object)
          __getobj__.matches?(response)
        end
      end
    end
  end
end
