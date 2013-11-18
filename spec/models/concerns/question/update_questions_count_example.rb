shared_examples_for 'update questions count for question model' do
  before do 
    @questions_count = @question_level.reload.questions_count
  end

  describe "after_create increase_questions_count" do 
    it "should increase the questions_count of category" do 
      Question.create(question: "What is this?", question_level_id: @question_level.id, user_id: @user.id, type: 'Subjective', tags_field: "also", category_field: "#{@category.id}", "options_attributes"=>{"1384334256874"=>{"answer"=>"1", "option"=>"asdfsafa", "_destroy"=>"false"}})
      @question_level.reload.questions_count.should eq(@questions_count + 1)
    end
  end

  describe "after_destroy decrease_questions_count" do 
    # it "should decrease the questions_count of category" do 
    #   @question.destroy
    #   @category.reload.questions_count.should eq(@questions_count - 1)
    # end
  end

  describe "after_update manage_questions_count" do 
    before do 
      @new_question_level = QuestionLevel.create(name: "avg")
      @new_level_questions_count = @new_question_level.questions_count
      @question.update_attributes(question_level_id: @new_question_level.id)
    end

    it "should decrease count from old level" do 
      @question_level.reload.questions_count.should eq(@questions_count - 1)
    end

    it "should increase in new level" do 
      @new_question_level.reload.questions_count.should eq(@new_level_questions_count + 1)
    end
  end
end