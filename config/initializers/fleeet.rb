# frozen_string_literal: true

API.setup do |config|
  config.api_base_class = 'APIController'
end

Authentication.setup do |config|
  config.for :user do |manager|
    manager.strategies = %i[bearer]
  end
  config.for :supplier do |manager|
    manager.strategies = %i[bearer]
    manager.user_class = User.supplier
  end
  config.for :operations do |manager|
    manager.strategies = %i[bearer]
    manager.user_class = User.operations
  end
  config.for :client do |manager|
    manager.strategies = %i[bearer]
    manager.user_class = User.client
  end
  config.warden do |manager|
    manager.default_strategies :bearer
    manager.default_scope = :user
    manager.intercept_401 = false
  end
end
