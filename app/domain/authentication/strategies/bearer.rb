# frozen_string_literal: true

module Authentication
  module Strategies
    # :reek:MissingSafeMethod { exclude: [ authenticate! ] }
    # allows access using Bearer token
    class Bearer < ::Warden::Strategies::Base
      extend Forwardable

      def_delegators :config, :user_class

      def valid?
        user_obj.present?
      end

      def authenticate!
        return success! user_obj if user_obj

        message = I18n.translate('apid_tango.errors.unauthorized_access.missing_user')
        fail! Errors::UnauthorizedAccess.new(message)
      end

      private

      def config
        @config ||= Authentication.config.for(scope)
      end

      def user_obj
        @user_obj ||= user_class.find_by(public_id: user_public_id)
      end

      def user_public_id
        @user_public_id ||= user_data.dig('iss')
      end

      def user_data
        @user_data ||= begin
          authorization = parse_authorization_header
          return {} unless authorization && authorization =~ /^Bearer (.*)/i

          Authentication::TokenFactory.new(validate: false).decode(Regexp.last_match(1))
        end
      end

      def parse_authorization_header
        key = 'HTTP_AUTHORIZATION'
        return unless env.include? key

        env[key]
      end
    end
  end
end

::Authentication::Strategies::Bearer.tap { |strategy| Warden::Strategies.add(:bearer, strategy) }
