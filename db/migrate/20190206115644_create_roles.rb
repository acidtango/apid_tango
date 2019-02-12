class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :name, null: true
      t.timestamps

      t.index :name, unique: true
    end

    create_table :user_roles do |t|
      t.references :role, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps

      t.index [:role_id, :user_id], unique: true, name: :unique_user_role
    end

    %w(supplier operations client).each { |role| Role.find_or_create_by(name: role) }
  end
end
