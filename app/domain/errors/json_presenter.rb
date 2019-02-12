# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Errors
  # Presenter for errors
  class JSONPresenter < Roar::Decorator
    include Roar::JSON

    def initialize(error)
      error = Collection.new([error]) unless error.is_a?(Collection)
      super error
    end

    collection :errors do
      property :status, type: :integer
      property :code
      property :title
      property :detail
      property :source
    end
  end
end
