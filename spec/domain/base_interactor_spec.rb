# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BaseInteractor do
  let(:context_class) do
    Class.new do
      def domain_use_case_success(_obj); end

      def domain_use_case_error(_obj); end
    end
  end
  let(:context) { instance_spy(context_class) }
  let(:interactor_name) { 'Domain::UseCaseInteractor' }
  let(:interactor_class_base) do
    klass = Class.new(described_class) do
      def apply; end
    end
    klass.tap { |c| allow(c).to receive(:name).and_return(interactor_name) }
  end
  let(:interactor_class) { interactor_class_base }
  let(:interactor) { interactor_class.new(context) }
  let(:result_obj) { 'result' }
  let(:error_obj) { instance_double(Errors::Base) }

  describe ':steps' do
    shared_context 'with explicit steps' do
      let(:interactor_class) do
        interactor_class_base.steps :step1, :step2
        interactor_class_base
      end
    end

    context 'with default step' do
      it { expect(interactor_class).to have_attributes(interactor_steps: [:apply]) }
    end

    context 'with user defined steps' do
      include_context 'with explicit steps'
      it { expect(interactor_class).to have_attributes(interactor_steps: %i[step1 step2]) }
    end

    context 'with user defined steps, through inheritance' do
      include_context 'with explicit steps'
      let(:child_interactor_class) do
        Class.new(interactor_class)
      end

      it { expect(child_interactor_class).to have_attributes(interactor_steps: %i[step1 step2]) }
    end
  end

  describe 'early exit' do
    before { interactor.call }

    let(:interactor_class) do
      interactor_class_base.class_eval do
        steps :first_step, :second_step

        def first_step
          early_success(5)
        end

        def second_step
          2
        end
      end
      interactor_class_base
    end

    it { expect(context).to have_received(:domain_use_case_success).with(5) }
  end

  describe 'callback' do
    it 'calls success callback when everything ok' do
      allow(interactor).to receive(:apply).and_return(result_obj)
      interactor.call
      expect(context)
        .to have_received(:domain_use_case_success).with(result_obj)
    end

    it 'calls error callback when something went wrong' do
      allow(interactor).to receive(:apply) { interactor.errors.push(error_obj) }
      interactor.call
      expect(context)
        .to have_received(:domain_use_case_error)
        .with(instance_of(Errors::Collection))
    end
  end
end
