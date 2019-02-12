# frozen_string_literal: true

module Authentication
  # Handles failure in authentication
  class FailureApp
    def self.call(env)
      new.call(env)
    end

    def call(_env)
      message_key = 'apid_tango.errors.unauthorized_access.missing_user'
      message = I18n.translate(message_key)
      error = Errors::UnauthorizedAccess.new(message)
      msg = ::Errors::JSONPresenter.new(error).to_json
      [error.status, {}, [msg]]
    end
  end
end
