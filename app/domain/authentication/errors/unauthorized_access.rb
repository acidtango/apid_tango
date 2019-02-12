# frozen_string_literal: true

module Authentication
  module Errors
    # Error for wrong credential to a service
    class UnauthorizedAccess < ::Errors::Base
      def initialize(*args)
        super
        self.status = 401
        self.title = I18n.t('apid_tango.errors.unauthorized_access.title')
      end

      def self.forbidden(*args)
        detail = I18n.t('apid_tango.errors.unauthorized_access.forbidden')
        UnauthorizedAccess.new(detail, *args)
      end
    end
  end
end
