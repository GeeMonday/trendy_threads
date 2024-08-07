ActiveAdmin.register Product do
  permit_params :name, :description, :price, :sale_price, :stock, :image, :on_sale

  filter :name
  filter :price
  filter :sale_price
  filter :on_sale, as: :boolean

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :price
    column :sale_price
    column :stock
    column :on_sale do |product|
      product.on_sale ? 'Yes' : 'No'
    end
    column :image do |product|
      if product.image.attached?
        image_tag url_for(product.image), size: "100x100"
      else
        "No Image"
      end
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price, min: 0.01, max: 10000  # Explicitly set max value if needed
      f.input :sale_price, min: 0.01, max: 10000  # Explicitly set max value if needed
      f.input :stock, min: 0
      f.input :on_sale, as: :boolean
      f.input :image, as: :file
    end
    f.actions
  end

  controller do
    def create
      @product = Product.new(permitted_params[:product])
      if @product.save
        redirect_to admin_product_path(@product), notice: "Product created successfully."
      else
        render :new
      end
    end

    def update
      @product = Product.find(params[:id])
      if @product.update(permitted_params[:product])
        redirect_to admin_product_path(@product), notice: "Product updated successfully."
      else
        render :edit
      end
    end
  end
end
