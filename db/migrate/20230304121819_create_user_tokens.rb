class CreateUserTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :user_tokens do |t|
      t.references :user, null: false

      t.string :label, null: false
      t.string :body, null: false
      t.json :meta, null: false, default: '{}'
      t.timestamp :activated_at
      t.timestamp :trashed_at

      t.timestamps null: false
    end
  end
end
