class AddUserTokenToSolutions < ActiveRecord::Migration[7.0]
  def change
    add_column :solutions, :user_token, :string
  end
end
