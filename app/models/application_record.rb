# frozen_string_literal: true

# Base class for all database repositories
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
