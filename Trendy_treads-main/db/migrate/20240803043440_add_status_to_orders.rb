class AddStatusToOrders < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:orders, :status)
      add_column :orders, :status, :integer, default: 0, null: false
    end
  end
end
