# frozen_string_literal: true

module Builders
  # builds an object using public setters with attributes defined from a hash
  module HashBuilder
    private

    def initialize_from_hash(opts = {})
      opts.each do |key, value|
        public_send("#{key}=", value)
      end
    end
  end
end
