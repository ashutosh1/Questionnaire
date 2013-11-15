class CategoriesController < ApplicationController
  
  load_resource only: [:update, :destroy]
  before_action :find_parent_and_initialize, only: :create

  authorize_resource
  respond_to :html, :json, only: :index

  def index
    @category = Category.new
    @roots = Category.roots.collect{|root| root.to_node } if request.xhr?
    respond_with(@roots)
  end

  def create
    if @category.save
      redirect_to categories_path, :notice => "#{@category.name} has been created successfully"
    else
      render :index
    end
  end

  def update
    if @category.update_values(params)
      flash.now[:notice] = "#{@category.name} has been updated successfully"
    else
      flash.now[:alert] = "#{@category.name} could not be updated"
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
      params.require(:category).permit(:name, :ancestry)
    end

    def find_parent_and_initialize
      if params[:category][:parent].blank?
        @category = Category.roots.build params_category
      else
        parent = Category.where(id: params[:category][:parent]).first
        @category = parent.children.build params_category
      end
    end
end