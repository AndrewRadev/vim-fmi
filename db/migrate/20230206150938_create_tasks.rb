class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.text :description

      t.text :input, null: false
      t.text :output, null: false

      t.timestamp :opens_at
      t.timestamp :closes_at, index: true
      t.integer :points, null: false, default: 1

      t.timestamps null: false
    end
  end
end
