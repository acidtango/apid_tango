# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role do
  let(:role) { build(:role) }

  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:user_roles) }
end
