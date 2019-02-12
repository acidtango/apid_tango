# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module Authentication
  # configuration options
  class Config
    # store of scoped config
    class ScopedConfigStore
      extend Forwardable

      def_delegators :@scoped_config, :each

      def initialize(parent)
        @parent = parent
        @scoped_config = {}
      end

      def for(scope)
        exists = @scoped_config.key?(scope)
        @scoped_config[scope] = @parent.clone unless exists
        config = @scoped_config[scope]
        yield config, exists
        config
      end
    end
    attr_accessor :warden_config, :password_length, :email_regexp, :mappings, :user_class,
                  :warden_config_blocks, :strategies

    def initialize
      @warden_config_blocks = []
      @listeners = []
      @scoped_config = ScopedConfigStore.new(self)
      yield self if block_given?
    end

    def warden(&block)
      warden_config_blocks << block
    end

    def scopes
      @scoped_config
    end

    def for(scope)
      @scoped_config.for(scope) do |config, exists|
        yield config if block_given?
        config.user_class ||= scope.to_s.classify.constantize
        notify_listeners scope, config unless exists
      end
    end

    def on_scope_registration(&block)
      @listeners << block
    end

    private

    def notify_listeners(scope, config)
      @listeners.each do |listener|
        listener.call(scope, config)
      end
    end
  end
end
