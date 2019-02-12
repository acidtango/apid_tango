# frozen_string_literal: true

module API
  # default error handling
  module ErrorHandling
    autoload :Test, File.expand_path('./error_handling/test', __dir__)

    def self.included(base)
      base.rescue_from StandardError, with: :rescue_standard_error
      base.rescue_from ActionController::ParameterMissing, with: :rescue_validation_error
      base.rescue_from Errors::Base, with: :rescue_custom_error
      base.rescue_from Errors::Collection, with: :rescue_custom_error
    end

    def rescue_custom_error(errors)
      errors = ErrorCoercion.error_collection_from(errors)
      render json: Errors::JSONPresenter.new(errors), status: errors.status
    end

    def rescue_standard_error(exception)
      ErrorLogger.new(exception).call
      rescue_custom_error(ErrorCoercion.error_from(exception, status: 500))
    end

    def rescue_validation_error(exception)
      param = exception.param
      message = I18n.t('apid_tango.errors.parameter_missing', param: param)
      rescue_custom_error(ErrorCoercion.error_from(message, status: 400, source: param))
    end

    # this method handles routing errors, to use setup config/routes.rb
    # match '*path' => 'controller#routing_error', via: %i[get post]
    def routing_error
      error = Errors::NotFound.new("No such route '#{params[:path]}'")
      rescue_custom_error(error)
    end

    # error logger
    ErrorLogger = Struct.new(:exception) do
      def call
        logger = Rails.logger
        logger.error exception.inspect
        logger.error exception.backtrace
      end
    end

    # error coercion logic
    module ErrorCoercion
      module_function

      def error_collection_from(error)
        if error.is_a?(Errors::Collection)
          error
        else
          Errors::Collection.new([error])
        end
      end

      def error_from(error, status: nil, source: nil)
        if error.is_a?(Errors::Base)
          error
        else
          Errors::Base.new(error, status: status, source: source)
        end
      end
    end
  end
end
