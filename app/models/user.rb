# frozen_string_literal: true

# User of the apid_tango service
class User < ApplicationRecord
  include ::Authentication::Trackable
  include ::Authentication::Authenticable

  belongs_to :organization, required: true
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :tokens

  scope :supplier, -> { joins(user_roles: :roles).where('roles.name = ?', 'supplier') }
  scope :operations, -> { joins(user_roles: :roles).where('roles.name = ?', 'operations') }
  scope :client, -> { joins(user_roles: :roles).where('roles.name = ?', 'client') }

  validates :email, presence: true, uniqueness: true
  validates :personal_number, presence: true, uniqueness: true

  def main_role
    roles.where(name: %w[client supplier]).order('roles.name DESC').first
  end

  def role?(role_name)
    if persisted?
      roles.where('name' => role_name).exists?
    else
      roles.detect { |role| role.name == role_name.to_s }
    end
  end
end
