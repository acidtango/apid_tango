# frozen_string_literal: true

RSpec.configure do |config|
  config.define_derived_metadata(file_path: Regexp.new('/spec/jobs/')) do |metadata|
    metadata[:type] = :jobs
  end
  config.include ActiveJob::TestHelper, type: :jobs
end
