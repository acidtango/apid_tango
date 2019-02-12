# frozen_string_literal: true

# Intermediate entity between users and roles
class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role
end
