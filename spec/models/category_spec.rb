require 'spec_helper'

describe Category do 
  
  it_should 'use category restrictive destroy'
  it_should 'should add audit callbacks'
    
  before(:each) do 
    @user = User.create(email: "ashutosh.tiwari@vinsol.com")
    @question_level = QuestionLevel.create(name: "beginner")
    @category = Category.create!(name: "GS")
    @question = Question.new(question: "What is sql?", type: "Subjective", question_level_id: @question_level.id, user_id: @user.id, "category_field"=>"1", "options_attributes"=>{"1384331840566"=>{"answer"=>"1", "option"=>"zxfvsdf", "_destroy"=>"false"}})
  end

  describe 'validation' do 
    it { should validate_presence_of(:name) }
  end

  describe "association" do 
    it { should have_many(:questions).through(:categories_questions) }
    it { should have_many(:categories_questions).dependent(:destroy) }
  end

  describe 'auto_strip_whitespace' do

    before do 
      @category1 = Category.new(:name => '  Test  ')
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

  describe "#to_node" do 
    it "should return a hash with name and id" do 
      @category.to_node.should eq({"label"=>"#{@category.name}", "id"=> @category.id,"children"=>[]})
    end
  end

  describe "#update_values" do 
    before do 
      @category2 = Category.create(name: "demo")
      @path = @category.path_ids
      p 
      @data = {:target_node => @category.id}
    end

    it "should update ancestry with path ids" do 
      @category2.update_values(@data)
      @category2.ancestry.should eq(@path.join("/"))
    end
  end

end