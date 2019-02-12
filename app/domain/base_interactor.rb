# frozen_string_literal: true

require 'uber/inheritable_attr'

# Common functionallity to all interactors
class BaseInteractor
  include Builders::HashBuilder
  extend Uber::InheritableAttr

  attr_reader :callee, :errors
  inheritable_attr :interactor_steps

  self.interactor_steps = [:apply]

  def initialize(callee, opts = {})
    @callee = callee
    @errors = ::Errors::Collection.new
    initialize_from_hash opts
  end

  def call
    step_iterator = StepIterator.new(self).consume
    callback_call(step_iterator.status, step_iterator.result)
  end

  def self.steps(*replacement)
    self.interactor_steps = replacement
  end

  protected

  def validate_active_record_object(object)
    object_errors = object.errors
    return object unless object_errors.any?

    errors.push_active_record_errors(object_errors)
  end

  # early success value
  EarlySuccess = Struct.new(:value)

  # :reek:UtilityFunction
  def early_success(value)
    EarlySuccess.new(value)
  end

  # iterate executing steps defined in interactor
  class StepIterator
    extend Forwardable
    def_delegators :@state, :result, :status

    # iterator state
    State = Struct.new(:result, :final, :status)

    def initialize(interactor)
      @interactor = interactor
      @steps = interactor.class.interactor_steps.map do |step|
        StepFunction.new(interactor, step)
      end
      @state = State.new(nil, false, :success)
    end

    def next?
      !@state.final && !@steps.empty?
    end

    def next
      step = @steps.shift
      new_result = step.call(result)
      update_state(new_result)
    end

    def consume
      self.next while next?
      self
    end

    private

    def update_state(new_result)
      if new_result.is_a?(EarlySuccess)
        @state = State.new(new_result.value, true, :success)
      elsif !errors.empty?
        @state = State.new(errors, true, :error)
      else
        @state.result = new_result
      end
      new_result
    end

    def errors
      @interactor.errors
    end
  end

  private

  # handle calls to step functions
  class StepFunction < SimpleDelegator
    def initialize(callee, step)
      super callee.method(step)
    end

    def call(result)
      args = arity == 1 ? [result] : []
      super(*args)
    end
  end

  def callback_prefix
    self.class.name.sub(/Interactor$/, '').underscore.tr('/', '_')
  end

  def callback(state)
    "#{callback_prefix}_#{state}"
  end

  def callback_call(state, *args)
    callee.public_send(callback(state), *args)
  end
end
