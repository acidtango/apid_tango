# frozen_string_literal: true

# JWT ID
class Token < ApplicationRecord
  belongs_to :user
end
