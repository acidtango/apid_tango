# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserRole do
  let(:user_role) { build(:user_role) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:role) }
end
