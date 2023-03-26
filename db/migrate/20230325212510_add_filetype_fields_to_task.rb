class AddFiletypeFieldsToTask < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :filetype, :string, null: true
    add_column :tasks, :file_extension, :string, null: true
  end
end
