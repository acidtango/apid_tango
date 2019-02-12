# frozen_string_literal: true

require_relative '../builders/hash_builder'

module Errors
  # Base class for all custom application errors
  class Base < StandardError
    include Builders::HashBuilder

    attr_accessor :code, :title, :status, :detail, :source

    def initialize(detail, opts = {})
      super(detail)
      self.detail = detail
      initialize_from_hash opts
    end
  end
end
