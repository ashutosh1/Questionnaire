class HomeController < ApplicationController
  skip_authorize_resource only: :index

  def index
    @tags = Question.tag_counts_on(:tags)
  end

  def show_tag
    @questions = Question.tagged_with(params[:tag], :on => :tags).includes(:question_type, :question_level, :user, :categories)
  end
end