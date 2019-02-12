# frozen_string_literal: true

Rails.application.routes.draw do
  resource :auth, only: %i[create update], controller: :authentication
  resource :registration, only: :create, controller: :registration
end
