class ProductsController < ApplicationController
  def index
    # Fetch all products initially
    @products = Product.all

    # Apply filters based on query parameters
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    if params[:on_sale]
      @products = @products.where(on_sale: true)
    end

    if params[:new]
      @products = @products.where('created_at >= ?', 3.days.ago)
    end

    if params[:recently_updated]
      @products = @products.where('updated_at >= ?', 3.days.ago)
    end

    if params[:name].present?
      @products = @products.where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%")
    end

    # Paginate the results
    @products = @products.page(params[:page]).per(10)

    # Fetch featured products
    @featured_products = Product.order(updated_at: :desc).limit(10)
  end

  def show
    @product = Product.find(params[:id])
  end
end
