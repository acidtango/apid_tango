# frozen_string_literal: true

module Errors
  # Error for wrong credential to a service
  class NotFound < ::Errors::Base
    def initialize(*args)
      super
      self.status = 404
      self.title = I18n.t 'apid_tango.errors.not_found.title'
    end
  end
end
