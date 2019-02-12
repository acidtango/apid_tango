# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization do
  let(:organization) { build(:organization) }

  it { expect(organization).to validate_presence_of(:name) }
  it { expect(organization).to validate_presence_of(:cif) }

  it { is_expected.to have_many(:users) }
end
