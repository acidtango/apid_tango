# frozen_string_literal: true

# error related classes and helpers
module Errors
  autoload :Base, File.expand_path('./errors/base', __dir__)
  autoload :NotFound, File.expand_path('./errors/not_found', __dir__)
  autoload :Collection, File.expand_path('./errors/collection', __dir__)
  autoload :ResourceNotFound, File.expand_path('./errors/resource_not_found', __dir__)
  autoload :JSONPresenter, File.expand_path('./errors/json_presenter', __dir__)
end
