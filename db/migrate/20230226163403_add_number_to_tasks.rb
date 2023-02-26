class AddNumberToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :number, :integer, null: false
    add_index :tasks, :number, unique: true
  end
end
