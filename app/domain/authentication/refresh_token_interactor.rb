# frozen_string_literal: true

module Authentication
  # refresh token logic
  class RefreshTokenInteractor < BaseInteractor
    extend Forwardable
    steps :fetch_token, :validate_jwt, :validate_jti, :refresh

    def_delegators :callee, :request

    def fetch_token
      bearer = request.headers.fetch('Authorization')
      return bearer.split(' ').last if bearer

      generate_error
    end

    def validate_jwt(token)
      jwt = TokenFactory.new(validate: false).decode(token)
      return generate_error unless UtilityTokenClass.new(jwt).valid?
      return login_entity_for(token) if UtilityDateClass.new(jwt.fetch('exp')).valid?

      jwt
    end

    def validate_jti(jwt)
      jti = Token.find_by(public_id: jwt.fetch('jti'))
      generate_error unless UtilityDateClass.new(jti.expiration).valid?
      jwt
    end

    def refresh(jwt)
      current_user = User.find_by(public_id: jwt.fetch('iss'))
      generate_error unless current_user
      access_token = TokenFactory.new(user: current_user).generate
      login_entity_for(access_token)
    end

    private

    # Utility class to validate if a date is greater than Time.now
    class UtilityDateClass
      attr_reader :date, :now

      def initialize(date)
        @date = date
        @now = Time.now.utc.to_i
      end

      def valid?
        return false unless date

        date.to_i > now
      end
    end

    # Utility class to validate if the token has the expected keys
    class UtilityTokenClass
      attr_reader :jwt

      def initialize(jwt)
        @jwt = jwt
      end

      def valid?
        expected_keys.all? { |key| jwt.key? key }
      end

      private

      def expected_keys
        %w[exp jti iss aud]
      end
    end

    def login_entity_for(token)
      early_success(Authentication::LoginEntity.new(access_token: token))
    end

    def generate_error
      message = I18n.t('apid_tango.errors.unauthorized_access.missing_user')
      title = I18n.t('apid_tango.errors.unauthorized_access.title')
      errors.push(::Errors::Base.new(message, status: 401, title: title))
    end
  end
end
