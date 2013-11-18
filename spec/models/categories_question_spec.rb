require 'spec_helper'

describe CategoriesQuestion do 

  it_should 'update questions count for categories question model'
  
  before(:each) do 
    @user = User.create(email: "ashutosh.tiwari@vinsol.com")
    @question_level = QuestionLevel.create(name: "beginner")
    @category = Category.create(name: 'test', questions_count: 0)
    @question = Question.create!(question: "What is sql?", question_level_id: @question_level.id, user_id: @user.id, type: 'Subjective', tags_field: "also", category_field: "#{@category.id}", "options_attributes"=>{"1384334256874"=>{"answer"=>"1", "option"=>"asdfsafa", "_destroy"=>"false"}})
    @categories_question = @category.categories_questions.first  
  end
  
  describe "association" do 
    it { should belong_to(:category) }
    it { should belong_to(:question) }
  end
end