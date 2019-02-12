# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'user authorized endpoint' do
  subject do
    endpoint_call
    JSON.parse(body) if body.present?
  end

  let(:unauthorized_message) do
    I18n.translate('apid_tango.errors.unauthorized_access.missing_user')
  end
  let(:unauthorized_title) do
    I18n.translate('apid_tango.errors.unauthorized_access.title')
  end

  let(:unauthorized_error) do
    { 'errors' => [{ 'status' => 401, 'title' => unauthorized_title,
                     'detail' => unauthorized_message }] }
  end

  context 'when no auth' do
    setup :ensure_not_logged_in

    it { is_expected.to respond_with(:unauthorized) }
    it { is_expected.to eq(unauthorized_error) }
  end

  context 'with unauthorized user' do
    setup :login_with_user

    it_behaves_like 'forbidden access'
  end

  context 'with authorized user' do
    setup :login_with_user

    it { is_expected.to respond_with(:success) }
  end
end
