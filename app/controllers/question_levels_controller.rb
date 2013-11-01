class QuestionLevelsController < ApplicationController
  before_action :find_question_levels, only: :index
  load_resource only: [:destroy, :update, :show]
  authorize_resource
  
  def index
    @question_level = QuestionLevel.new
  end

  def create
    @question_level = QuestionLevel.new params_question_level
    if @question_level.save
      redirect_to question_levels_path, :notice => "#{@question_level.name} has been created successfully"
    else
      find_question_levels
      render :index
    end
  end

  def show
    return redirect_to request.referrer if !request.xhr?
  end

  def update
    if @question_level.update_attributes(params_question_level)
      redirect_to question_levels_path, :notice => "#{@question_level.name} has been updated successfully"
    else
      find_question_levels
      render :index
    end
  end

  def destroy
    if @question_level.destroy
      flash[:notice] = "#{@question_level.name} has been deleted successfully"
    else
      flash[:alert] = "#{@question_level.name} could not be deleted. please delete the associated questions first"
    end
    redirect_to question_levels_path
  end
  
  private
    def find_question_levels
      @question_levels = QuestionLevel.order('created_at desc')
    end

    def params_question_level
      params.require(:question_level).permit(:name)
    end

end