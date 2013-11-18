class QuestionsController < ApplicationController
  include ActsAsTaggableOn

  autocomplete :tag, :name, :class_name => ActsAsTaggableOn::Tag, :full => true, :id_element => '#some_element'
  autocomplete :category, :name, :full => true

  load_resource only: [:show, :update, :destroy, :edit, :publish, :unpublish]
  authorize_resource

  def index
    @questions = current_class_name.includes(:question_level, :user, :categories, :tags, :test_sets)
    @questions = @questions.where(question_level_id: params[:question_level_id]) if params[:question_level_id]
  end

  def new
    @question = current_user.questions.build
    @options = @question.options.build
  end

  def create
    @question = current_user.questions.build params_question
    if @question.save
      redirect_to questions_path, :notice => "Question has been created successfully"
    else
      @options = @question.options 
      render :new
    end
  end

  def update
    if @question.update_attributes(params_question)
      redirect_to questions_path, :notice => "Question has been updated successfully"
    else
      @options = @question.options 
      render :edit
    end
  end

  def destroy
    if @question.destroy
      flash[:notice] = "Question has been deleted successfully"
    else
      flash[:alert] = "Question could not be deleted. please delete the associated questions first"
    end
    redirect_to :back
  end

  def publish
    @question.publish!
    redirect_to :back, :notice => "Question successfully published"
  end

  def unpublish
    if @question.unpublish!
      flash[:notice] = "Question successfully unpublished"
    else
      flash[:alert] = "Question is associated with test sets (#{@question.test_sets.collect(&:name).join(', ')}), so it can not be unpublished."
    end
    redirect_to :back
  end

  private

    def params_question
      params.require(:question).permit(:question, :question_level_id, :type, :user_id, :tags_field, :category_field, :options_attributes => [:option, :answer, :id, :_destroy])
    end

    def current_class_name
      return params[:type].classify.constantize if params[:type]
      Question
    end

end