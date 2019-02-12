# frozen_string_literal: true

# Roles for users
class Role < ApplicationRecord
  has_many :user_roles
  has_many :users, through: :user_roles

  def self.supplier
    Role.find_by(name: 'supplier')
  end

  def self.client
    Role.find_by(name: 'client')
  end

  def self.operations
    Role.find_by(name: 'operations')
  end
end
