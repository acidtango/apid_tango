# frozen_string_literal: true

require 'roar/json/json_api'
require 'roar/decorator'

module Roar
  module JSON
    module JSONAPI
      # options namespace
      module Options
        # include links
        module IncludeLinks
          # :reek:FeatureEnvy
          def call(options, mappings)
            opts = super
            return opts unless opts.key?(:include) && opts[:wrap] != false

            included = opts[:include]
            opts[:include] = included + [:links] unless included&.include?(:links)
            opts
          end
        end
        Include.prepend(IncludeLinks)
      end
    end
  end
end

# Common functionallity to all presenters
class BasePresenter < Roar::Decorator
  include Rails.application.routes.url_helpers

  def self.resource(type, options = {})
    include Roar::JSON::JSONAPI.resource type, options
  end
end
