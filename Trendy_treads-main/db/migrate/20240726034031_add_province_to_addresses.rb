class AddProvinceToAddresses < ActiveRecord::Migration[7.1]
  def change
    add_column :addresses, :province, :string
  end
end
