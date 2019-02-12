# frozen_string_literal: true

module Authentication
  # login logic
  class LoginInteractor < BaseInteractor
    attr_accessor :username, :password

    def apply
      return login_entity if current_user&.try(:authenticate, password)

      generate_error
    end

    private

    def current_user
      @current_user ||= User.joins(:roles).find_by(email: username)
    end

    def login_entity
      Authentication::LoginEntity.new(access_token: access_token)
    end

    def access_token
      @access_token ||= TokenFactory.new(user: current_user).generate
    end

    def generate_error
      message = I18n.t('apid_tango.errors.unauthorized_access.missing_user')
      title = I18n.t('apid_tango.errors.unauthorized_access.title')
      errors.push(::Errors::Base.new(message, status: 401, title: title))
    end
  end
end
