# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    require File.expand_path('../../db/seeds', __dir__)
  end
end
