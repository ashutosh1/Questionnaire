class CategoriesController < ApplicationController
  before_action :find_category, only: [:update, :destroy]

  def index
    @categories = Category.all.arrange
  end

  def new
    @category = Category.new(ancestry_id: params[:ancestry_id])
  end

  def create
    @category = Category.new params_category
    if @category.save
      redirect_to categories_path, :notice => "#{@category.name} has been created successfully"
    else
      render :new
    end
  end

  def update
    if @category.update_attributes(params_category)
      redirect_to categories_path, :notice => "#{@category.name} has been updated successfully"
    else
      redirect_to categories_path, :alert => "#{@category.name} could not be updated"
    end
  end

  def destroy
    if @category.destroy
      redirect_to categories_path, :notice => "#{@category.name} has been deleted successfully"
    else
      redirect_to categories_path, :alert => "#{@category.name} could not be deleted, please remove associated questions."
    end
  end

  private 
    def params_category
      params.require(:category).permit(:name, :ancestry_id)
    end

    def find_category
      @category = Category.where(id: params[:id]).first
      redirect_to :back, :alert => "Category not found for specified id" unless @category
    end
end