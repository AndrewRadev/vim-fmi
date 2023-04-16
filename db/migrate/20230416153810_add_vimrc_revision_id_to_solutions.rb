class AddVimrcRevisionIdToSolutions < ActiveRecord::Migration[7.0]
  def change
    add_column :solutions, :vimrc_revision_id, :bigint, null: true
  end
end
