# frozen_string_literal: true

module Authentication
  # presents information about login action
  class LoginPresenter < Roar::Decorator
    include Roar::JSON

    property :access_token, as: 'access-token'
  end
end
