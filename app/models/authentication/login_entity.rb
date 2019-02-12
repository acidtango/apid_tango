# frozen_string_literal: true

module Authentication
  # login information struct
  class LoginEntity
    include Builders::HashBuilder

    attr_accessor :access_token

    def initialize(attributes = {})
      initialize_from_hash(attributes)
    end
  end
end
