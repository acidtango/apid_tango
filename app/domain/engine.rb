# frozen_string_literal: true

# Rails Engine for Fleeet
class Engine < ::Rails::Engine
  isolate_namespace Fleeet

  config.app_middleware.use Warden::Manager do |config|
    ::Authentication.config.warden_config = config
  end

  config.after_initialize do
    ::Authentication.configure_warden!
  end

  config.generators do |generator|
    generator.test_framework :rspec
  end
end
