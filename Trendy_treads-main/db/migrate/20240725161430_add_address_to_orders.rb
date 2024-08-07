class AddAddressToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :address, :string
    add_column :orders, :province, :string
    add_column :orders, :payment_method, :string
  end
end
