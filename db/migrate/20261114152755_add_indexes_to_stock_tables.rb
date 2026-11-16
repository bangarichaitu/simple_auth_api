class AddIndexesToStockTables < ActiveRecord::Migration[7.1]
  def change
    add_index :stock_balances,
              [:company_id, :category_id],
              unique: true

    add_index :stock_transactions, :transaction_type

    add_index :stock_transactions, :transaction_date

    add_index :stock_transactions,
              [:company_id, :category_id],
              name: "index_stock_transactions_on_company_category"
  end
end
