class AddCodeToProvinces < ActiveRecord::Migration[7.1]
  def change
    add_column :provinces, :code, :string
  end
end
