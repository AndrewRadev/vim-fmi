class AddPointsBreakdownToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :points_breakdown, :json, null: false, default: '{}'
  end
end
