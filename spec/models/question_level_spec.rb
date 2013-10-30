require 'spec_helper'

describe QuestionLevel do 
  it_should 'use restrictive destroy'
  
  before(:each) do 
    @user = User.create(email: "ashutosh.tiwari@vinsol.com")
    @question_type = QuestionType.create(name: "subjective")
    @question_level = QuestionLevel.create(name: "beginner")
    @question = Question.create(question: "What is sql?", question_type_id: @question_type.id, question_level_id: @question_level.id, user_id: @user.id)
  end

  describe 'validation' do 
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe "association" do 
    it { should have_many(:questions) }
  end
  
  describe 'auto_strip_whitespace' do

    before do 
      @question_level1 = QuestionLevel.new(:name => '  Test  ')
    end

    it "valid? should return false if it find name is present in db after strip" do
      question_level = QuestionLevel.new(:name => '    beginner     ')
      question_level.valid?.should eq(false) 
    end  

    it 'should strip white space from start and end of property_group name and then validate it' do
      @question_level1.valid?
      @question_level1.name.should eq('Test')
    end
  end

end