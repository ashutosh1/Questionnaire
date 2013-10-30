class QuestionTypesController < ApplicationController
  before_action :find_question_types, only: :index
  before_action :find_question_type, only: [:show, :update, :destroy]
  authorize_resource
  
  def index
    @question_type = QuestionType.new
  end

  def create
    @question_type = QuestionType.new params_question_type
    if @question_type.save
      redirect_to question_types_path, :notice => "#{@question_type.name} has been created successfully"
    else
      find_question_types
      render :index
    end
  end

  def show
  end

  def update
    if @question_type.update_attributes(params_question_type)
      redirect_to question_types_path, :notice => "#{@question_type.name} has been updated successfully"
    else
      find_question_types
      render :index
    end
  end

  def destroy
    if @question_type.destroy
      flash[:notice] = "#{@question_type.name} has been deleted successfully"
    else
      flash[:alert] = "#{@question_type.name} could not be deleted. please delete the associated questions first"
    end
    redirect_to question_types_path
  end
  
  private
    def find_question_types
      @question_types = QuestionType.order('created_at desc')
    end

    def find_question_type
      @question_type = QuestionType.where(id: params[:id]).includes(:questions).first
      redirect_to :back, :alert => "No question type found for specified id" unless @question_type
    end

    def params_question_type
      params.require(:question_type).permit(:name)
    end

end