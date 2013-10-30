require 'spec_helper'

describe Category do 
  
  it_should 'use category restrictive destroy'
    
  before(:each) do 
    @user = User.create(email: "ashutosh.tiwari@vinsol.com")
    @question_type = QuestionType.create(name: "subjective")
    @question_level = QuestionLevel.create(name: "beginner")
    @question = Question.create(question: "What is sql?", question_type_id: @question_type.id, question_level_id: @question_level.id, user_id: @user.id)
    @category = Category.create(name: "GS")
  end

  describe 'validation' do 
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:ancestry) }
  end

  describe "association" do 
    it { should have_many(:questions).through(:categories_questions) }
    it { should have_many(:categories_questions).dependent(:destroy) }
  end

  describe 'auto_strip_whitespace' do

    before do 
      @category1 = Category.new(:name => '  Test  ')
    end

    it "valid? should return false if it find name is present in db after strip" do
      category = Category.new(:name => '    GS     ')
      category.valid?.should eq(false) 
    end  

    it 'should strip white space from start and end of property_group name and then validate it' do
      @category1.valid?
      @category1.name.should eq('Test')
    end
  end

  describe "has_ancestry" do 
    it "should define a class methods has_ancestry" do 
      Category.methods.include?(:has_ancestry).should be_true
    end

    it "should define some scopes" do
      Category.methods.include?(:roots).should be_true
      Category.methods.include?(:ancestors_of).should be_true
      Category.methods.include?(:children_of).should be_true
      Category.methods.include?(:descendants_of).should be_true
      Category.methods.include?(:subtree_of).should be_true
      Category.methods.include?(:siblings_of).should be_true
      Category.methods.include?(:ordered_by_ancestry).should be_true
      Category.methods.include?(:ordered_by_ancestry_and).should be_true
    end

    it "should define some callback methods" do 
      @category.methods.include?(:update_descendants_with_new_ancestry).should be_true
      @category.methods.include?(:apply_orphan_strategy).should be_true
    end
  end

end