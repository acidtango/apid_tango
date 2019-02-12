# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    public_id { SecureRandom.hex 6 }
    email { SecureRandom.hex(10) + '@acidtango.com' }
    name { SecureRandom.hex(10) }
    personal_number { SecureRandom.hex 4 }
    phone { SecureRandom.hex 4 }
    password { 'password' }
    association :organization

    transient do
      privileged { false }
    end

    trait :with_supplier_role do
      privileged { :supplier }
    end

    trait :with_client_role do
      privileged { :client }
    end

    trait :with_operations_role do
      privileged { :operations }
    end

    after(:build) do |obj, evaluator|
      if evaluator.privileged == :supplier
        obj.roles << Role.supplier
      elsif evaluator.privileged == :client
        obj.roles << Role.client
      elsif evaluator.privileged == :operations
        obj.roles << Role.operations
      elsif obj.roles.blank?
        obj.roles << Role.supplier
      end
    end

    factory :user_supplier, traits: %i[with_supplier_role]
    factory :user_client, traits: %i[with_client_role]
    factory :user_operations, traits: %i[with_operations_role]
  end
end
