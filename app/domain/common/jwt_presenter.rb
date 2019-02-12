# frozen_string_literal: true

module Common
  # format data as expected for jwt
  class JWTPresenter
    def initialize(represented, options = {})
      @represented = represented
      @options = options
    end

    def to_json
      representation['iss'] = @options[:iss]
      representation['exp'] = @options[:exp]
      representation['aud'] = @options[:aud]
      representation['jti'] = @options[:jti]
      representation
    end

    private

    def representation
      @representation ||= Users::ShowPresenter.new(@represented).to_hash
    end
  end
end
