class AddScriptKeysToSolutions < ActiveRecord::Migration[7.0]
  def change
    add_column :solutions, :script_keys, :string, array: true
  end
end
