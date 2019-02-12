# frozen_string_literal: true

module Errors
  # Error for wrong credential to a service
  class ResourceAlreadyExists < Errors::Base
    def initialize(*args)
      super
      self.status = 409
      self.title = I18n.t 'models.errors.resource_already_exists.title'
    end
  end
end
