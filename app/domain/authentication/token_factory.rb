# frozen_string_literal: true

module Authentication
  # Utility class to generate jwt with RS256
  class TokenFactory
    attr_reader :opts

    JWT_ALGORITHM = 'RS256'

    def initialize(opts = {})
      @opts = opts
    end

    def generate
      JWT.encode jwt_payload, rsa_private, JWT_ALGORITHM
    end

    def decode(token)
      JWT.decode(token, rsa_public, with_validations, algorithm: JWT_ALGORITHM)[0]
    end

    private

    def user
      @user ||= opts.fetch(:user)
    end

    def with_validations
      @with_validations ||= opts.fetch(:validate, true)
    end

    def rsa_public
      @rsa_public ||= rsa_private.public_key
    end

    def rsa_private
      @rsa_private ||= OpenSSL::PKey::RSA.new File.read ENV['JWT_PUBLIC_KEY']
    end

    def token_public_id
      loop do
        public_id = SecureRandom.hex 6
        return public_id unless Token.where(public_id: public_id).exists?
      end
    end

    def jti_token
      @jti_token ||= Token.create(public_id: token_public_id, user: user,
                                  expiration: 3.months.from_now.utc)
    end

    def exp
      @exp ||= opts.fetch(:exp, 3.hours.from_now.utc).to_i
    end

    def jti
      @jti ||= opts.fetch(:jti, jti_token.public_id)
    end

    def jwt_payload
      Users::JWTPresenter.new(user, iss: user.public_id, exp: exp,
                                    jti: jti, aud: user.main_role.name).to_json
    end
  end
end
