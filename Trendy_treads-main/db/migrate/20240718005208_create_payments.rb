class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.integer :order_id
      t.string :payment_method
      t.decimal :amount
      t.timestamps
    end
  end
end
