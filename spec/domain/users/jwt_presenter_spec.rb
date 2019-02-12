# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::JWTPresenter do
  subject(:presenter) do
    described_class.new(user, iss: user.public_id, exp: exp, jti: jti, aud: user.main_role.name)
                   .to_json
  end

  let(:url) { 'https://api.testing' }
  let(:user) { create(:user, :with_supplier_role) }
  let(:jti) { SecureRandom.hex(6) }
  let(:exp) { 3.hours.from_now.utc }
  let(:aud) { 'supplier' }

  it { is_expected.to eq_json_id(user.public_id.to_s) }
  it { is_expected.to include('exp', 'jti', 'aud') }
  it { causes { presenter.dig('exp') }.to eq(exp) }
  it { causes { presenter.dig('jti') }.to eq(jti) }
  it { causes { presenter.dig('aud') }.to eq(aud) }
end
