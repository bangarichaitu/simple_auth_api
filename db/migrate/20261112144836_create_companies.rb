class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.text :address
      t.string :contact_number

      t.timestamps
    end
  end
end
