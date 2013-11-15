class TestSetsController < ApplicationController
  include GenerateAndSendSets

  load_resource only: [:show, :download_sets], :find_by => :permalink
  before_action :assign_variables, only: :search_questions
  before_action :filter_and_get_num_of_questions, only: :search_questions
  before_action :find_questions, only: :create
  
  authorize_resource

  def index
    @test_sets = TestSet.order("created_at desc").paginate(page: params[:page], per_page: 100)
  end

  def create
    @test_set = TestSet.new params_test_set
    @test_set.questions = @questions
    if @test_set.save
      if params[:num_of_sets].present?
        generate_and_send_sets(params[:num_of_sets].to_i)
      else
        redirect_to test_sets_path, :notice => "Test Set has been created successfully"
      end
    else
      render "search_questions"
    end
  end

  def download_sets
    generate_and_send_sets(params[:num_of_sets].to_i)
  end

  def search_questions
    @test_set = TestSet.new
  end

  private

    def params_test_set
      params.require(:test_set).permit(:name, :instruction)
    end
    
    def assign_variables
      @question_types, @query, @categories, @tags = params[:query].keys, params[:query], params[:category], params[:tags]
    end

    def filter_and_get_num_of_questions
      @questions, @errors = TestSet.get_questions(@question_types, @query, @categories, @tags)
    end

    def find_questions
      @questions = Question.where(id: params[:question_id].split(" "))
      redirect_to :back, :alert => "There are no questions for this test set" unless @questions
    end

end
