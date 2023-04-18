class CreateFreeTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :free_tasks do |t|
      t.references :user, null: false, index: true

      t.string :label, null: false
      t.text :description
      t.string :file_extension
      t.string :filetype
      t.text :input, null: false
      t.text :output, null: false
      t.datetime :hidden_at

      t.timestamps null: false
    end
  end
end
