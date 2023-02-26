class AddCompletedAtToSolutions < ActiveRecord::Migration[7.0]
  def change
    add_column :solutions, :completed_at, :datetime, null: true
  end
end
