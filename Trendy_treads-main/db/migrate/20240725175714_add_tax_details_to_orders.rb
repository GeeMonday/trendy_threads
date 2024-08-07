class AddTaxDetailsToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :subtotal, :decimal, precision: 10, scale: 2
    add_column :orders, :gst, :decimal, precision: 10, scale: 2
    add_column :orders, :pst, :decimal, precision: 10, scale: 2
    add_column :orders, :hst, :decimal, precision: 10, scale: 2
  end
end
