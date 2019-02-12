# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    public_id { SecureRandom.hex 6 }
    name { "org-#{SecureRandom.hex(6)}" }
    cif { SecureRandom.hex 12 }
  end
end
