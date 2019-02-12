# frozen_string_literal: true

# base class for application controllers
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include ::Authentication::Helpers::RailsHelpers
end
