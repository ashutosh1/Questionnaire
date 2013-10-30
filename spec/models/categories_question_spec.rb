require 'spec_helper'

describe CategoriesQuestion do 
  
  before(:each) do 
    @user = User.create(email: "ashutosh.tiwari@vinsol.com")
    @question_type = QuestionType.create(name: "subjective")
    @question_level = QuestionLevel.create(name: "beginner")
    @question = Question.create(question: "What is sql?", question_type_id: @question_type.id, question_level_id: @question_level.id, user_id: @user.id)
    @category = Category.create(name: "GS")
    @category.questions << @question
    @categories_question = @category.categories_questions    
  end
  
  describe "association" do 
    it { should belong_to(:category) }
    it { should belong_to(:question) }
  end
end