# frozen_string_literal: true

RSpec.shared_examples 'endpoint that requires authentication' do
  subject do
    endpoint_call
    JSON.parse(body)
  end

  let(:unauthorized_message) do
    I18n.translate('apid_tango.errors.unauthorized_access.missing_user')
  end
  let(:unauthorized_title) do
    I18n.translate('apid_tango.errors.unauthorized_access.title')
  end

  let(:unauthorized_error) do
    { 'errors' => [{ 'status' => 401,
                     'title' => unauthorized_title,
                     'detail' => unauthorized_message }] }
  end

  setup :ensure_not_logged_in

  it { is_expected.to respond_with(:unauthorized) }
  it { is_expected.to eq(unauthorized_error) }
end

Authentication.config.scopes.each do |scope, _config|
  RSpec.shared_examples "#{scope} authenticated endpoint" do
    subject do
      endpoint_call
      JSON.parse(body)
    end

    it_behaves_like 'endpoint that requires authentication'

    context 'authenticated user' do
      public_send(:setup, "login_with_#{scope}")
      subject { endpoint_call }

      it { is_expected.to respond_with(:success) }
    end
  end
end
