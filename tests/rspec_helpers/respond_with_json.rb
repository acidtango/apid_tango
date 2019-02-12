# frozen_string_literal: true

module Tests
  module RSpecHelpers
    # Adds a helper method to refer to calls on subject
    module RespondWithJSON
      def respond_with_json
        RespondWithJSONMatcher.new(self)
      end

      def json_response
        subject
        JSON.parse(response.body)
      end

      # Matches againts the response object the http status
      class RespondWithJSONMatcher
        attr_accessor :base
        attr_reader :description

        def initialize(base)
          @base = base
          @description = 'respond with json'
          @matcher = nil
        end

        def matches?(_obj_)
          json_response? && chain_matching_ok?
        end

        def that(matcher)
          @matcher = matcher
          @description += ' that ' + matcher.description
          self
        end

        def failure_message
          return 'Response has no json format' unless json_response?

          @matcher.failure_message
        end

        private

        def chain_matching_ok?
          !@matcher || @matcher.matches?(json_response)
        end

        def json_response
          @json_response ||= begin
            JSON.parse(base.response.body)
                             rescue JSON::ParserError => error
                               error
          end
        end

        def json_response?
          !json_response.is_a?(JSON::ParserError)
        end
      end
    end
  end
end
