class RemoveUnwantedAddressFieldsFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :address_id, :integer
    remove_column :users, :address_zip_code, :string
    remove_column :users, :address_state, :string
    remove_column :users, :address_city, :string
    remove_column :users, :address_street, :string
  end
end
