class AddActiveToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :active, :boolean , default: true, null: false
  end
end
