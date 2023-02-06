class CreateSignUps < ActiveRecord::Migration[7.0]
  def change
    create_table :sign_ups do |t|
      t.string :full_name
      t.string :faculty_number

      t.string :email, null: true
      t.string :token, null: true

      t.timestamps
    end
  end
end
