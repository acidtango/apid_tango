# frozen_string_literal: true

# top level namespace for api related classes
module API
  base_dir = File.expand_path('./api', __dir__)
  autoload :ErrorHandling, File.join(base_dir, 'error_handling')
  autoload :Callbacks, File.join(base_dir, 'callbacks')
  autoload :Configuration, File.join(base_dir, 'configuration')
  autoload :Translation, File.join(base_dir, 'translation')

  # Helper class to setup JSONAPI configuration
  module JSONAPI
    autoload :Interactor, File.expand_path('api/json_api/interactor', __dir__)
  end

  def self.setup(*args, &block)
    Configuration.configure(*args, &block)
  end
end
