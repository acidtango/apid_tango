# frozen_string_literal: true

require_relative '../encryptor'

module Authentication
  # adds password management logic
  module Authenticable
    extend ActiveSupport::Concern

    included do
      has_secure_password
    end

    def after_password_authentication; end
  end
end
