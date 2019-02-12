# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BasePresenter do
  include Tests::RSpecHelpers::JSONApi

  subject { presenter_class.new(presenter_object).to_hash }

  let(:presenter_class) do
    Class.new(described_class) do
      resource :tests

      attributes do
        property :name
      end
    end
  end

  let(:presenter_object) { OpenStruct.new(id: 1, name: 'name') }

  it { is_expected.to eq_json_id('1') }
  it { is_expected.to eq_json_attributes(name: 'name') }
end
