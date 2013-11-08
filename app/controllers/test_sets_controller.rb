class TestSetsController < ApplicationController
  before_action :find_test_set, only: [:show, :download_sets]
  before_action :assign_variables, only: :create
  before_action :filter_and_get_num_of_questions, only: :create
  authorize_resource

 def index
  # CR_Priyank: Use pagination
  @test_sets = TestSet.all.order("created_at desc")
 end

  def new
    @test_set = TestSet.new
  end

  def create
    @test_set = TestSet.new params_test_set
    if @questions.present?
      @test_set.questions << @questions
      if @test_set.save
        generate_and_send_sets
      else
        render :new
      end
    else
      flash[:alert] = "Questions not found for selected combination. Please try with different questions combinations."
      render :new
    end
  end

  def show
  end

  def download_sets
    @num_of_sets = params[:num_of_sets].to_i
    generate_and_send_sets
  end

  private

    def params_test_set
      params.require(:test_set).permit(:name, :number, :instruction)
    end
    
    def assign_variables
      @question_type_ids, @query, @num_of_sets = params[:query].keys, params[:query], params[:num_of_sets].to_i
    end

    def filter_and_get_num_of_questions
      @questions = TestSet.get_questions(@question_type_ids, @query)
    end

    # CR_Priyank: This can be moved to concern
    def generate_and_send_sets
      TestSet.generate_different_sets(@num_of_sets, @test_set)
      send_data(File.new(Rails.root.join("public/reports/#{@test_set.file_name}.zip")).read, :type=>"application/zip" , :filename => "#{@test_set.file_name}.zip")
      File.delete(Rails.root.to_s + "/public/reports/#{@test_set.file_name}.zip")
    end

    def find_test_set
      @test_set = TestSet.where(id: params[:id]).includes(questions: :question_type).first
      redirect_to :back, :alert => "No test set found for specified id" unless @test_set
    end

end
