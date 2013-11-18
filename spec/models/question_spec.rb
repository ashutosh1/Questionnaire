require 'spec_helper'

describe Question do 

  it_should "use taggable module"
  it_should 'should add audit callbacks'
  it_should 'update questions count for question model'
  
  before(:each) do 
    @user = User.create!(email: "ashutosh.tiwari@vinsol.com")
    @question_level = QuestionLevel.create(name: "beginner")
    @category = Category.create(name: 'test', questions_count: 0)
    @question = Question.create!(question: "What is sql?", question_level_id: @question_level.id, user_id: @user.id, type: 'Subjective', tags_field: "also", category_field: "#{@category.id}", "options_attributes"=>{"1384334256874"=>{"answer"=>"1", "option"=>"asdfsafa", "_destroy"=>"false"}})
  end

  describe 'validation' do 
    it { should validate_presence_of(:question) }
    it { should validate_presence_of(:question_level) }
    it { should validate_presence_of(:user) }
  end

  describe "association" do 
    it { should belong_to(:user) }
    it { should belong_to(:question_level) }
   
    it { should have_many(:options).dependent(:destroy) }
    it { should have_many(:categories).through(:categories_questions) }
    it { should have_many(:categories_questions).dependent(:destroy) }
    it { should have_and_belong_to_many(:test_sets) }
    it { should have_many(:answers).class_name('Option') }
  end

  describe "accept_nested_attributes_for" do 
    it { should accept_nested_attributes_for(:options).allow_destroy(true) }
  end

  describe "scope published" do 
    context "question is published" do 
      before do 
        @question.publish!
      end

      it "should return @question" do
        Question.published.should eq([@question]) 
      end
    end

    context "question is not published" do 
      before do 
        @question
      end

      it "should return blank" do
        Question.published.should eq([]) 
      end
    end
  end

  describe "scope unpublished" do 
    context "question is published" do 
      before do 
        @question.publish!
      end

      it "should return blank" do
        Question.unpublished.should eq([]) 
      end
    end

    context "question is unpublished" do 
      it "should return unpublished questions" do
        Question.unpublished.should eq([@question]) 
      end
    end
  end

  describe "#published?" do 
    context "published_at is nil" do 
      it "should return false" do 
        @question.published?.should eq(false)
      end
    end

    context "published_at is not nil" do 
      before do 
        @question.publish!
      end

      it "should return true" do 
        @question.published?.should eq(true)
      end
    end
  end

  describe "#unpublish!" do
    it "should update the published_at to nil" do 
      @question.unpublish!
      @question.published_at.should be_nil
    end
  end

  describe "#publish!" do 
    before do 
      @question.publish!
    end

    it "should update published_at  with time" do 
      @question.published_at.should_not be_nil
    end
  end

  describe "#destroyable_by_user?" do 
    context "user created question" do 
      it "should return true" do 
        @question.destroyable_by_user?(@user).should eq(true)
      end
    end

    context "user not created question" do 
      before do 
        @question.update_column(:user_id, 90001)
      end

      context "user is super_admin" do 
        before do 
          @user.stub(:has_role?).with(:super_admin).and_return(true)
        end

        it "should return true" do 
          @question.destroyable_by_user?(@user).should eq(true)
        end
      end

      context "user is not super_admin" do 
        before do 
          @user.stub(:has_role?).with(:super_admin).and_return(false)
        end

        it "should return false" do 
          @question.destroyable_by_user?(@user).should eq(false)
        end
      end
    end
  end


end