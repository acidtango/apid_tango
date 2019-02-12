# frozen_string_literal: true

require_relative 'authentication/config'
require_relative 'authentication/failure_app'
require_relative 'authentication/strategies'
require_relative 'authentication/warden_hooks'

# top level namespace for all authentication related logic
module Authentication
  %i[Authenticable Trackable].each do |model|
    file = "./authentication/model/#{model.to_s.underscore}"
    autoload model, File.expand_path(file, __dir__)
  end

  # Authentication related errors
  module Errors
    autoload :UnauthorizedAccess,
             File.expand_path('./authentication/errors/unauthorized_access', __dir__)
  end

  # top level namespace for helper modules
  module Helpers
    autoload :RailsHelpers,
             File.expand_path('./authentication/helpers/rails_helpers', __dir__)
  end

  mattr_accessor :config

  self.config = Config.new do |config|
    config.warden_config = nil
    config.password_length = 6..72
    config.email_regexp = /\A([\w\.%\+\-]+)@([a-z0-9\-]+\.)+([\w]{2,})$\z/i
  end

  def self.warden_config
    config.warden_config
  end

  def self.setup
    yield config
  end

  # This is invoked once all routes have been set.
  # This is to have all the mappings defined, so we can create all helpers.
  # rubocop:disable Naming/MemoizedInstanceVariableName
  def self.configure_warden!
    @_warden_configured ||= begin
      warden_config.failure_app = FailureApp
      warden_config.default_strategies(:password)

      Authentication.config.scopes.each do |name, config|
        configure_warden_scope(warden_config, name, config)
      end
      config.warden_config_blocks.each do |block|
        block.call Authentication.warden_config
      end
    end
  end
  # rubocop:enable Naming/MemoizedInstanceVariableName

  def self.configure_warden_scope(warden_config, name, config)
    warden_config.scope_defaults(name, strategies: config.strategies)

    warden_config.serialize_into_session(name, &:id)

    warden_config.serialize_from_session(name) do |id|
      config.user_class.find_by(id: id)
    end
  end
end
