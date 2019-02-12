# frozen_string_literal: true

# base class for application controllers
class APIController < ActionController::API
  include Authentication::Helpers::RailsHelpers
  include API::ErrorHandling
  include API::Callbacks
  include API::Translation

  protected

  def presenter_params
    params.permit(:include, :fields).slice(:include, :fields).to_hash.transform_keys(&:to_sym)
  end
end
