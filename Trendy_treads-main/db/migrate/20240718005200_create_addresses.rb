class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.references :user, foreign_key: true, index: true
      t.string :street
      t.string :city
      t.string :province  # Add this line
      t.string :postal_code
      t.string :country
      t.timestamps
    end
  end
end
