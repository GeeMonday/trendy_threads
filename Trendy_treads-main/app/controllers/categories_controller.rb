class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end
  
  def show
    @category = Category.find(params[:id])
    @products = @category.products.page(params[:page]).per(10) # Paginate products
    @product_categories = ProductCategory.where(category_id: @category.id)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to @category, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, product_ids: [])
  end
end
