class CreateSolutions < ActiveRecord::Migration[7.0]
  def change
    create_table :solutions do |t|
      t.references :user, null: false
      t.references :task, null: false
      t.string :token, null: false
      t.binary :script, null: true
      t.json :meta, null: false, default: '{}'
      t.integer :points, null: false, default: 0

      t.timestamps null: false
    end
  end
end
