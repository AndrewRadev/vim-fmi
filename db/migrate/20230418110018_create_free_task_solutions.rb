class CreateFreeTaskSolutions < ActiveRecord::Migration[7.0]
  def change
    create_table :free_task_solutions do |t|
      t.references :user, null: false, index: true
      t.references :free_task, null: false, index: true
      t.references :vimrc_revision, index: false

      t.string :token, null: false
      t.string :user_token

      t.binary :script
      t.string :script_keys, array: true
      t.json :meta, null: false, default: '{}'
      t.datetime :completed_at

      t.timestamps null: false
    end
  end
end
