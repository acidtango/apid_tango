# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /auth' do
  subject(:endpoint_call) { post '/auth', params: params }

  let(:params) { { username: username, password: password } }
  let(:user) { create(:user) }
  let(:user_id) { user.public_id }
  let(:username) { user.email }
  let(:password) { user.password }
  let(:token_public_id) { SecureRandom.hex 6 }
  let(:jwt) { json_response['access-token'] }

  before do
    allow(SecureRandom).to receive(:hex).and_return(token_public_id)
  end

  describe 'no auth' do
    let(:params) { { username: username, password: 'fakePassword' } }

    it_behaves_like 'endpoint that requires authentication'
  end

  describe 'expires in 3 hours by default' do
    instantiate_before :jwt

    it { at(3.hours.from_now) { expect(jwt).not_to be_a_jwt(iss: user_id) } }
  end

  describe 'generates refresh token' do
    let(:refresh_token) { user.tokens.last }

    it do
      expect(json_response).to include('access-token' => eq(jwt))
    end
  end
end
