class AddAddressLine1ToAddresses < ActiveRecord::Migration[7.1]
  def change
    add_column :addresses, :address_line1, :string
  end
end
