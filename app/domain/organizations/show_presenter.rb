# frozen_string_literal: true

module Organizations
  # Presenter for organizations
  class ShowPresenter < BasePresenter
    attributes :name, :cif

    has_many :users
  end
end
