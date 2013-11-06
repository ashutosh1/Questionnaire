class QuestionsController < ApplicationController
  include ActsAsTaggableOn
  autocomplete :tag, :name, :class_name => ActsAsTaggableOn::Tag, :full => true
  
  before_action :find_question, only: [:show, :update, :destroy, :edit, :remove_tag]
  authorize_resource

  def index
    if params[:question_level_id]
      @questions = Question.where(question_level_id: params[:question_level_id]).includes(:question_type, :question_level, :user, :categories)
    elsif params[:question_type_id]
      @questions = Question.where(question_type_id: params[:question_type_id]).includes(:question_type, :question_level, :user, :categories)
    else
      @questions = Question.includes(:question_type, :question_level, :user, :categories)
    end
  end

  def new
    @question = current_user.questions.build
    build_categories_questions
  end

  def create
    @question = current_user.questions.build params_question
    if @question.save
      redirect_to questions_path, :notice => "Question has been created successfully"
    else
      build_categories_questions
      render :new
    end
  end

  def show
  end

  def edit
    build_categories_questions
  end

  def update
    if @question.update_attributes(params_question)
      redirect_to questions_path, :notice => "Question has been updated successfully"
    else
      build_categories_questions
      render :edit
    end
  end

  def destroy
    if @question.destroy
      flash[:notice] = "Question has been deleted successfully"
    else
      flash[:alert] = "Question could not be deleted. please delete the associated questions first"
    end
    redirect_to questions_path
  end

  def remove_tag
    @question.remove_tags(params[:tag_name])
    flash.now[:notice] = "Tag #{params[:tag_name]} has been removed successfully"
  end

  private

    def find_question
      @question = Question.where(id: params[:id]).includes(:question_type, :question_level, :user, :categories).first
      redirect_to :back, :alert => "No question type found for specified id" unless @question
    end

    def params_question
      params.require(:question).permit(:question, :question_level_id, :question_type_id, :user_id, :tags_field, :categories_questions_attributes => [:category_id, :id, :_destroy], :options_attributes => [:option, :answer, :id, :_destroy])
    end

    def build_categories_questions
      if (@categories_questions = @question.categories_questions + Category.where(["id NOT IN (?)", @question.categories_questions.collect(&:category_id)]).collect { |question| question.categories_questions.build }).blank?
        @categories_questions = Category.all.collect{|question| question.categories_questions.build }
      end
    end


end