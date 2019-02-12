# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'forbidden access' do
  let(:forbidden_message) do
    I18n.translate('apid_tango.errors.restricted_access.message')
  end
  let(:forbidden_title) do
    I18n.translate('apid_tango.errors.restricted_access.title')
  end

  let(:forbidden_error) do
    { 'errors' => [{ 'status' => 403, 'title' => forbidden_title,
                     'detail' => forbidden_message }] }
  end

  it { is_expected.to respond_with_json.that eq(forbidden_error) }
end
