# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :name,       null: false
      t.string :cif,        null: false
      t.string :public_id,  null: false
      t.timestamps

      t.index :cif, unique: true
      t.index :public_id, unique: true
      t.index [:name, :cif], unique: true, name: :index_organizations_on_name_and_cif
    end
  end
end
