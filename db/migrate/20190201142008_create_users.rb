# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string  :name,             null: false
      t.string  :surnames
      t.string  :email,            null: false
      t.string  :personal_number
      t.string  :password_digest
      t.string  :phone,            null: false
      t.integer :organization_id,  null: false
      t.string  :public_id,        null: false

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      t.timestamps null: false

      t.index :email, unique: true
      t.index :organization_id
      t.index :public_id, unique: true
      t.index [:email, :organization_id], name: :index_users_on_email_and_organization_id, unique: true, using: :btree
    end
  end
end
