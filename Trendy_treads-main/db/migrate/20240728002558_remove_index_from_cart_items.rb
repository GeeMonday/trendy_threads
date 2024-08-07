class RemoveIndexFromCartItems < ActiveRecord::Migration[7.1]
  def change
    # Remove the index from the order_id column
    remove_index :cart_items, :order_id

    # Optionally, remove the order_id column if it is no longer needed
    # remove_column :cart_items, :order_id, :integer
  end
end
