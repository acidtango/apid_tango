# frozen_string_literal: true

module API
  # callbacks utilities
  module Callbacks
    def self.included(base)
      base.include InstanceMethods
      base.extend ClassMethods
    end

    # callbacks class methods
    module ClassMethods
      def default_error_callback(*args)
        args.each do |method|
          alias_method method, :default_error_callback
        end
      end
    end

    # callbacks instance methods
    module InstanceMethods
      def default_error_callback(errors)
        status = errors.status || 400
        render json: Errors::JSONPresenter.new(errors), status: status
      end
    end
  end
end
