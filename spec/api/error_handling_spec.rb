# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::ErrorHandling do
  let(:controller_class) do
    Class.new(ActionController::Base) { include API::ErrorHandling }
  end
  let(:controller) { controller_class.new }
  let(:presenter_class) { Errors::JSONPresenter }
  let(:message) { 'test message' }

  before do
    allow(controller).to receive(:render)
    allow(controller).to receive(:params).and_return(path: '/path')
    call_method
  end

  describe '#rescue_standard_error' do
    let(:call_method) { controller.rescue_standard_error(error) }
    let(:error) { StandardError.new(message) }

    it do
      expect(controller).to have_received(:render).with(json: be_a(presenter_class), status: 500)
    end
  end

  describe '#rescue_custom_error' do
    let(:call_method) { controller.rescue_custom_error(error) }
    let(:status) { 304 }
    let(:error) { Errors::Base.new(message, status: status) }

    it do
      expect(controller).to have_received(:render).with(json: be_a(presenter_class), status: status)
    end
  end

  describe '#rescue_validation_error' do
    let(:call_method) { controller.rescue_validation_error(error) }
    let(:error) { ActionController::ParameterMissing.new(message) }

    it do
      expect(controller).to have_received(:render).with(json: be_a(presenter_class), status: 400)
    end
  end

  describe '#routing_error' do
    let(:call_method) { controller.routing_error }

    it do
      expect(controller).to have_received(:render).with(json: be_a(presenter_class), status: 404)
    end
  end
end
