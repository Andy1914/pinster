class Api::CategoriesController < Api::ApplicationController
  
  def index
    @categories = Category.all
  end

end