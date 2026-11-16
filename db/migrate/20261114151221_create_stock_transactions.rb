class CreateStockTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :stock_transactions do |t|
      t.references :company, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :hotel, foreign_key: true
      t.string :transaction_type
      t.decimal :quantity, precision: 12, scale: 3,
                           null: false
      t.decimal :rate, precision: 12, scale: 2,
                       default: 0, null: false
      t.decimal :balance_after, precision: 12, scale: 3,
                                null: false
      t.date :transaction_date, null: false
      t.text :remarks

      t.timestamps

    end
  end
end


StockTransaction.create!(
  company: Company.last,
  category: Category.last,
  transaction_type: :in,
  quantity: 500,
  rate: 350,
  balance_after: 500,
  transaction_date: Date.today
)