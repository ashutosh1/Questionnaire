require 'spec_helper'

describe TestSet do 
  it_should 'should add audit callbacks'
  # it_should 'use search questions module'
  
  before do
    @user = User.create(email: "ashutosh.tiwari@vinsol.com")
    @test_set = TestSet.create!(name: "demo test", instruction: "test")
    @ql1 = QuestionLevel.create(name: "avg")
    @ql2 = QuestionLevel.create(name: "beginner")
    @category = Category.create(name: "test")
    @question1 = Question.create!(question: "What is sql?", question_level_id: @ql1.id, user_id: @user.id, type: 'Subjective', tags_field: "also", category_field: "#{@category.id}", "options_attributes"=>{"1384334256874"=>{"answer"=>"1", "option"=>"asdfsafa", "_destroy"=>"false"}})
    @question2 = Question.create!(question: "How r u?", question_level_id: @ql2.id, user_id: @user.id, type: 'Subjective', tags_field: "also", category_field: "#{@category.id}", "options_attributes"=>{"1384334256874"=>{"answer"=>"1", "option"=>"asdfsafa", "_destroy"=>"false"}})
  end
  
  describe "association" do 
    it { should have_and_belong_to_many(:questions) }
  end

  describe 'validation' do 
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:instruction) }
  end

  describe"#file_name" do 
    it "should return name with underscore replacing space" do
      @test_set.file_name.should eq("demo_test")
    end
  end

  describe "destroyable?" do 
    it "should return false" do 
      @test_set.destroyable?.should eq(false)
    end
  end

  describe "has_permalink:name" do 
    it "should define a before_filter generate_permalink" do 
      @test_set.should_receive(:generate_permalink)
      @test_set.save
    end

    it "should genrate unique permalink" do 
      @test_set1 = TestSet.create!(name: "demo test", instruction: "test")
      @test_set1.permalink.should_not eq(@test_set.permalink)
    end
  end

end