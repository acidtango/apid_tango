# frozen_string_literal: true

module Tests
  module RSpecHelpers
    # Adds a helper method to refer to calls on subject
    module IsExpectedOnCall
      # rubocop:disable Naming/PredicateName
      def is_expected_on_call
        expect { subject }
      end
      # rubocop:enable Naming/PredicateName
    end
  end
end
