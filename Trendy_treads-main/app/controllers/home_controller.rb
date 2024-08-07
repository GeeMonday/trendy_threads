class HomeController < ApplicationController
  def index
    @static_pages = StaticPage.all
    @categories = Category.all
    @featured_products = Product.limit(5) # Adjust the query as needed
  end
end

