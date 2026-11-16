class CreateHotels < ActiveRecord::Migration[7.1]
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :contact_person
      t.string :phone
      t.text :address
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
