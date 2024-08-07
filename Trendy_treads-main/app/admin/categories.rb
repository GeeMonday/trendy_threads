ActiveAdmin.register Category do

  # Permit the parameters for category, including associated product IDs
  permit_params :name, product_ids: []

  filter :name # Example filter for 'name'

  index do
    selectable_column
    id_column
    column :name
    column :products do |category|
      category.products.pluck(:name).join(', ')  # Display associated products
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :products, as: :check_boxes, collection: Product.all.map { |p| [p.name, p.id] }  # Checkboxes for selecting products
    end
    f.actions
  end

end
