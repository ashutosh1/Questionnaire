class QuestionsController < ApplicationController
  include ActsAsTaggableOn
  autocomplete :tag, :name, :class_name => ActsAsTaggableOn::Tag, :full => true, :id_element => '#some_element'
  autocomplete :category, :name, :full => true

  load_resource only: [:show, :update, :destroy, :edit, :remove_tag, :publish, :unpublish]
  authorize_resource

  def index
    if params[:question_level_id]
      @questions = Question.where(question_level_id: params[:question_level_id])
    else
      @questions = Question.question_with_type(params[:type])
    end
    @questions = @questions.includes(:question_level, :user, :categories)
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
    # CR_Priyank: I am not sure why are we rescuing this block ?
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
    redirect_to :back
  end

  def remove_tag
    @question.remove_tags(params[:tag_name])
    flash.now[:notice] = "Tag #{params[:tag_name]} has been removed successfully"
  end

  def publish
    @question.publish
    redirect_to questions_path, :notice => "Question successfully published"
  end

  def unpublish
    if @question.unpublish
      flash[:notice] = "Question successfully unpublished"
    else
      flash[:alert] = "Question is associated with test sets (#{@question.test_sets.collect(&:name).join(', ')}), so it can not be unpublished."
    end
    redirect_to questions_path
  end

  private

    def params_question
      params.require(:question).permit(:question, :question_level_id, :type, :user_id, :tags_field, :categories_questions_attributes => [:category_id, :id, :_destroy], :options_attributes => [:option, :answer, :id, :_destroy])
    end

    def build_categories_questions
      # CR_Priyank: I think {|question|} should be category, also try to move this code in model
      @categories_questions = @question.build_categories_questions
    end

end