class AddAddressFieldsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :address_zip_code, :string
  end
end
