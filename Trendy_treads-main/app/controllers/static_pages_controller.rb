class StaticPagesController < ApplicationController
  def show
    # Attempt to find a StaticPage by title
    @page = StaticPage.find_by(title: params[:title])
    
    # If not found, show a 404 page
    if @page.nil?
      render file: 'public/404.html', status: :not_found
    end
  end
end
