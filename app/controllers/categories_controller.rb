class CategoriesController < ApplicationController
  respond_to :json, :html

  def index
    respond_with Category.all
  end

  def create
    respond_with Category.create category_params
  end

  def destroy
    respond_with Category.destroy params[:id]
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
