# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Token do
  let(:token) { build(:token) }

  it { expect(token).to belong_to(:user) }
  it { expect(token).to validate_presence_of(:expiration) }
  it { expect(token).to validate_presence_of(:public_id) }
end
