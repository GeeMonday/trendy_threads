class AddAddressFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :address_street, :string
    add_column :users, :address_city, :string
    add_column :users, :address_state, :string
    add_column :users, :address_zip_code, :string
  end
end
