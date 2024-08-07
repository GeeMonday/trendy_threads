class RemoveAddressIdAndUserIdIndexesFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_index :users, :address_id if index_exists?(:users, :address_id)
    remove_index :users, :user_id if index_exists?(:users, :user_id)
  end
end
