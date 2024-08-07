class AddTaxRatesToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :gst_rate, :decimal, precision: 5, scale: 2
    add_column :orders, :pst_rate, :decimal, precision: 5, scale: 2
    add_column :orders, :hst_rate, :decimal, precision: 5, scale: 2
  end
end
