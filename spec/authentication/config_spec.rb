# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authentication::Config do
  let(:config) { described_class.new { |c| c.user_class = Class.new } }

  describe 'change config value' do
    let(:new_value) { SecureRandom.hex(10) }

    it do
      expect { config.password_length = new_value }
        .to change(config, :password_length).from(nil).to(new_value)
    end
  end

  describe 'scoped config' do
    subject!(:scoped_config) do
      config.for(scope) do |manager|
        manager.password_length = scope_value
      end
    end

    let(:scope) { 'scope' }
    let(:regexp) { /regexp/ }
    let(:global_value) { SecureRandom.hex(10) }
    let(:scope_value) { SecureRandom.hex(10) }
    let(:config) do
      described_class.new do |c|
        c.password_length = global_value
        c.email_regexp = regexp
        c.user_class = Class.new
      end
    end

    it { expect(config.password_length).to eq(global_value) }
    it { expect(scoped_config.password_length).to eq(scope_value) }
    it { expect(scoped_config.email_regexp).to eq(regexp) }
    it { expect(config.for(scope)).to eq(scoped_config) }
  end

  describe 'scope registration notification' do
    let(:listener) { spy }
    let(:scope) { 'scope' }

    before do
      config.on_scope_registration do |scope, config|
        listener.call(scope, config)
      end
    end

    describe 'no initial config' do
      subject!(:scope_config) { config.for scope }

      it { expect(listener).to have_received(:call) }
    end

    describe 'initial config' do
      subject!(:scope_config) do
        config.for(scope) { |c| c.password_length = 3 }
      end

      it { expect(listener).to have_received(:call) }
    end
  end
end
