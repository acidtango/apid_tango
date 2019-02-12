# frozen_string_literal: true

module Errors
  # Error for missing requested resource
  class ResourceNotFound < Base
    def initialize(*args)
      super
      self.status = 404
      self.title = I18n.t 'apid_tango.errors.resource_not_found.title'
    end
  end
end
