# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:user) { build(:user) }

  it { expect(user).to validate_presence_of(:public_id) }
  it { expect(user).to validate_presence_of(:name) }
  it { expect(user).to validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { expect(user).to validate_presence_of(:email) }

  it { is_expected.to belong_to(:organization) }
  it { is_expected.to have_many(:roles) }
end
