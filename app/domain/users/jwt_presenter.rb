# frozen_string_literal: true

module Users
  # format data as expected for jwt
  class JWTPresenter
    def initialize(user, options = {})
      @user = user
      @options = options
    end

    def to_json
      %i[iss exp jti aud].each { |tag| representation[tag.to_s] = @options[tag] }
      representation
    end

    private

    def representation
      @representation ||= Users::ShowPresenter.new(@user).to_hash
    end
  end
end
