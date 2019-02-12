# frozen_string_literal: true

module Errors
  # Base class for all custom application errors
  class Collection < StandardError
    extend Forwardable
    attr_accessor :errors
    def_delegators :@errors, :empty?, :any?, :first, :each, :map, :each_with_index

    def initialize(*errors)
      @errors = []
      push(*errors)
    end

    def push(*input_errors)
      input_errors.flatten.each do |error|
        if error.is_a?(::Errors::Base)
          errors.push(error)
        else
          errors.push(::Errors::Base.new(error))
        end
      end
    end

    def push_active_record_errors(input_errors)
      input_errors.to_hash(true).each do |attribute, messages|
        push_errors_with_source(attribute, messages)
      end
    end

    def push_errors_with_source(source, input_errors)
      input_errors.each do |message|
        errors.push(::Errors::Base.new(message, source: source))
      end
    end

    def status
      errors.map(&:status).max
    end

    def to_s
      if errors.empty?
        'Empty error collection'
      else
        errors.map(&:detail).join(', ')
      end
    end
  end
end
