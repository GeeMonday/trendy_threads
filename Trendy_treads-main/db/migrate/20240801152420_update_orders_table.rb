class UpdateOrdersTable < ActiveRecord::Migration[6.1]
  def change
    # Remove unused columns
    remove_column :orders, :gst_rate, :decimal
    remove_column :orders, :pst_rate, :decimal
    remove_column :orders, :hst_rate, :decimal
    remove_column :orders, :address_zip_code, :string
    remove_column :orders, :address_state, :string
  end
end
