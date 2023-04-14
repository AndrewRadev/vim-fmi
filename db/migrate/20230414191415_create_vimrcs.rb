class CreateVimrcs < ActiveRecord::Migration[7.0]
  def change
    create_table :vimrcs do |t|
      t.references :user, null: false, index: true
      t.timestamps null: false
    end

    create_table :vimrc_revisions do |t|
      t.references :vimrc, null: false, index: true
      t.text :body, null: false
      t.timestamps null: false
    end
  end
end
