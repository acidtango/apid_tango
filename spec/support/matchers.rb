# frozen_string_literal: true

module RSpec
  # validates de length of a collection
  # :reek:InstanceVariableAssumption
  class ValidateCollectionLengthOf < Shoulda::Matchers::ActiveModel::ValidateLengthOfMatcher
    def string_of_length(length)
      klass = @subject.class.reflections[@attribute.to_s].klass
      [klass.new] * length
    end
  end

  # custom matchers
  # :reek:UtilityFunction
  module Matchers
    def validate_collection_length_of(relation)
      ::RSpec::ValidateCollectionLengthOf.new(relation)
    end
  end
end

RSpec::Matchers.define :be_a_jwt do |data|
  match do |actual|
    data[:verify_iss] = true if data.key?(:iss)
    rsa_private = OpenSSL::PKey::RSA.new File.read(ENV['JWT_PUBLIC_KEY'])
    rsa_public = rsa_private.public_key
    JWT.decode actual, rsa_public, true, algorithm: 'RS256', **data
  rescue JWT::InvalidIssuerError, JWT::ExpiredSignature
    false
  end
end

Tests::RSpecHelpers::RouteTo.defaults = { format: 'json' }

RSpec.configure do |config|
  config.include ::RSpec::Matchers
  config.include Tests::RSpecHelpers::RouteTo
end

RSpec::Matchers.define_negated_matcher :not_change, :change
