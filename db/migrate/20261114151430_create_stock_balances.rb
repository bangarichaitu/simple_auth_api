class CreateStockBalances < ActiveRecord::Migration[7.1]
  def change
    create_table :stock_balances do |t|
      t.references :company, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.decimal :quantity, precision: 12, scale: 3,
                           default: 0, null: false

      t.timestamps
    end
  end
end
