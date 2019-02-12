# frozen_string_literal: true

require 'bcrypt'

module Authentication
  # utility to generate and validate encrypted passwords
  class Encryptor
    DEFAULT_COST = 10

    def self.digest(password)
      password = "#{password}#{password_pepper}" if password_pepper.present?
      ::BCrypt::Password.create(password, cost: DEFAULT_COST).to_s
    end

    def self.compare(encrypted_password, password)
      return false if encrypted_password.blank?

      bcrypt = ::BCrypt::Password.new(encrypted_password)
      password = "#{password}#{password_pepper}" if password_pepper.present?
      password = ::BCrypt::Engine.hash_secret(password, bcrypt.salt)
      secure_compare(password, encrypted_password)
    end

    # rubocop:disable Lint/UselessAccessModifier
    private_class_method
    # rubocop:enable Lint/UselessAccessModifier

    def self.password_pepper
      @password_pepper ||= Rails.application.secrets.password_pepper
    end

    # Constant-time comparison algorithm to prevent timing attacks.
    # Taken from Devise.
    # rubocop:disable Naming/UncommunicativeMethodParamName
    def self.secure_compare(a, b)
      return false if a.blank? || b.blank? || a.bytesize != b.bytesize

      l = a.unpack("C#{a.bytesize}")
      res = 0
      b.each_byte { |byte| res |= byte ^ l.shift }
      res.zero?
    end
    # rubocop:enable Naming/UncommunicativeMethodParamName
  end
end
