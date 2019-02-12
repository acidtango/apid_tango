# frozen_string_literal: true

# an user may be a part of an organization
class Organization < ApplicationRecord
  has_many :users

  validates :name, presence: true, uniqueness: true
  validates :cif, presence: true, uniqueness: true
end
