shared_examples_for 'update questions count for categories question model' do
  describe "after_save increase_questions_count" do 
    it "should increase the questions_count of category" do 
      questions_count = @category.reload.questions_count
      @categories_question.increase_questions_count
      @category.reload.questions_count.should eq(questions_count + 1)
    end
  end

  describe "after_destroy decrease_questions_count" do 
    it "should decrease the questions_count of category" do 
      questions_count = @category.reload.questions_count
      @categories_question.destroy
      @category.reload.questions_count.should eq(questions_count - 1)
    end
  end
end