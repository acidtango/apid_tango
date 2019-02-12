# frozen_string_literal: true

FactoryBot.define do
  factory :token do
    expiration { Time.now.utc.in(30.days) }
    public_id { SecureRandom.hex(6) }
    association :user, factory: :user
  end
end
