# app/admin/tax_rates.rb
ActiveAdmin.register TaxRate do
  permit_params :province_id, :gst, :pst, :hst

  index do
    selectable_column
    id_column
    column 'Province' do |tax_rate|
      tax_rate.province.name
    end
    column :gst
    column :pst
    column :hst
    actions
  end

  form do |f|
    f.inputs do
      f.input :province, as: :select, collection: Province.all.collect { |p| [p.name, p.id] }
      f.input :gst
      f.input :pst
      f.input :hst
    end
    f.actions
  end

  filter :province
  filter :gst
  filter :pst
  filter :hst
end
