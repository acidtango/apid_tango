# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PATCH /auth' do
  subject(:endpoint_call) { patch '/auth', headers: { 'Authorization': "Bearer #{token}" } }

  let(:user) { create(:user) }
  let(:user_id) { user.public_id }

  describe 'with valid token but no need to be refreshed' do
    let(:token) { Authentication::TokenFactory.new(user: user).generate }

    it { expect(json_response).to include('access-token' => eq(token)) }
  end

  describe 'with an expired jwt and valid jti token' do
    let(:expiration) { (Time.now.utc - 1.hour).to_i }
    let(:token) do
      Authentication::TokenFactory.new(user: user, exp: expiration, jti: jti).generate
    end
    let(:jti) { create(:token, user: user, expiration: 1.day.from_now.utc).public_id }
    let(:refresh_token) { Authentication::TokenFactory.new.decode(json_response['access-token']) }

    it { expect(refresh_token['exp'].to_i).to be > expiration }
  end

  describe 'with expired token and jti token' do
    let(:expiration) { Time.now.utc - 1.hour }
    let(:token) do
      Authentication::TokenFactory.new(user: user, exp: expiration.to_i, jti: jti).generate
    end
    let(:jti) { create(:token, user: user, expiration: expiration).public_id }

    it_behaves_like 'endpoint that requires authentication'
  end

  describe 'with invalid jwt' do
    let(:token) do
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4' \
      'gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c'
    end

    it_behaves_like 'endpoint that requires authentication'
  end
end
