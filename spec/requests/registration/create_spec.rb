# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /registration' do
  subject(:endpoint_call) { post '/registration', params: params }

  let(:params) do
    { name: 'test', username: username, password: password, scope: scope,
      organization_name: organization_name, organization_cif: organization_cif,
      personal_number: personal_number, phone: phone }
  end

  let(:username) { 'test@acidtango.com' }
  let(:password) { SecureRandom.hex(6) }
  let(:personal_number) { SecureRandom.hex(6) }
  let(:phone) { SecureRandom.hex(6) }
  let(:scope) { 'client' }
  let(:created_user) { User.order(:created_at).last }
  let(:apid_tango) { Organization.find_by(name: 'Apid Tango') }
  let(:created_organization) { Organization.order(:created_at).last }
  let(:login_entity) { Authentication::LoginEntity.new(access_token: SecureRandom.hex(10)) }
  let(:presenter) { Authentication::LoginPresenter }
  let(:login_interactor) { Authentication::LoginInteractor }
  let(:login_spy) { instance_spy(login_interactor) }
  let(:organization_name) { apid_tango.name }
  let(:organization_cif) { apid_tango.cif }

  before do
    allow(login_interactor).to receive(:new).and_return(login_spy)
    allow(login_spy).to receive(:call).and_return(login_entity)
  end

  describe 'correct user creation when organization not exists' do
    let(:organization_name) { "org-#{SecureRandom.hex(3)}" }
    let(:organization_cif) { SecureRandom.hex 6 }

    it { is_expected_on_call.to change(User, :count).by(1) }
    it { is_expected_on_call.to change(Organization, :count).by(1) }
    it { is_expected.to respond_with :created }
    it { is_expected.to respond_with_json.that eq(JSON.parse(presenter.new(login_entity).to_json)) }
    it { causes { created_user.organization.name }.to eq(organization_name) }
  end

  describe 'correct user creation when organization exists' do
    it { is_expected_on_call.to change(User, :count).by(1) }
    it { is_expected_on_call.not_to change(Organization, :count) }
    it { is_expected.to respond_with :created }
    it { is_expected.to respond_with_json.that eq(JSON.parse(presenter.new(login_entity).to_json)) }
    it { causes { created_user.organization.name }.to eq(organization_name) }
  end

  describe 'correct user role creation when user exists' do
    let(:user) { create(:user, :with_supplier_role, email: username, organization: apid_tango) }

    before { user }

    it { is_expected_on_call.not_to change(User, :count) }
    it { is_expected_on_call.to change(UserRole, :count).by(1) }
    it { is_expected_on_call.not_to change(Organization, :count) }
    it { is_expected.to respond_with :created }
    it { is_expected.to respond_with_json.that eq(JSON.parse(presenter.new(login_entity).to_json)) }
    it { causes { created_user.organization.name }.to eq(organization_name) }
  end

  describe 'errors on user creation when email already is taken' do
    let(:user) { create(:user, :with_supplier_role, email: username, organization: apid_tango) }
    let(:scope) { user.main_role.name }
    let(:title) { 'The specified resource already exists' }

    before { user }

    it { is_expected_on_call.not_to change(User, :count) }
    it { is_expected_on_call.not_to change(UserRole, :count) }
    it { is_expected.to respond_with_json.that include_json_error(status: 409, title: title) }
  end
end
