# db/migrate/XXXXXX_create_tax_rates.rb
class CreateTaxRates < ActiveRecord::Migration[6.0]
  def change
    create_table :tax_rates do |t|
      t.references :province, null: false, foreign_key: true
      t.decimal :gst, precision: 5, scale: 2, default: 0.0
      t.decimal :pst, precision: 5, scale: 2, default: 0.0
      t.decimal :hst, precision: 5, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
