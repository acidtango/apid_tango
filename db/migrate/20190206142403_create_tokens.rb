class CreateTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :tokens do |t|
      t.string :public_id, null: false
      t.references :user, foreign_key: true
      t.datetime :expiration, null: false
      t.timestamps

      t.index [:public_id, :expiration]
    end
  end
end
