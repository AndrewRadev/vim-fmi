class CreateVouchers < ActiveRecord::Migration[7.0]
  def change
    create_table :vouchers do |t|
      t.string :code, null: false
      t.belongs_to :user
      t.datetime :claimed_at

      t.timestamps null: false
    end
  end
end
