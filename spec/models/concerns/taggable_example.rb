shared_examples_for 'use taggable module' do
  describe "acts_as_taggable" do 
    it { should have_many(:base_tags).through(:taggings).class_name("ActsAsTaggableOn::Tag") }
    it { should have_many(:taggings).dependent(:destroy).class_name("ActsAsTaggableOn::Tagging") }
  end
  
  describe "attr_accessor tags_field" do
    before do 
      @obj = described_class.new
      @obj.tags_field = "Testing attr_accessor"
    end

    describe "reader method" do 
      it "should read the tags_field" do 
        @obj.tags_field.should eq("Testing attr_accessor")
      end
    end

    describe "writer method" do 
      it "should set tags_field value" do 
        @obj.tags_field = "test"
        @obj.tags_field.should eq("test")
        @obj.tags_field.should_not eq("Testing attr_accessor")
      end
    end
  end

  describe "#add_tags" do
    before do 
      @question = Question.create!(question: "What ?", question_level_id: @question_level.id, user_id: @user.id, type: 'Subjective', tags_field: "", category_field: "#{@category.id}", "options_attributes"=>{"1384334256874"=>{"answer"=>"1", "option"=>"asdfsafa", "_destroy"=>"false"}})
    end

    describe "should_receive methods" do 
      it "should_receive add_tags" do 
        @question.should_receive(:add_tags)
        @question.save
      end
    end

    describe "tags_field is present" do 
      before do 
        @category = Category.create(name: 'test', questions_count: 0)
        @question = Question.create!(question: "What is sql?", question_level_id: @question_level.id, user_id: @user.id, type: 'Subjective', tags_field: "also", category_field: "#{@category.id}", "options_attributes"=>{"1384334256874"=>{"answer"=>"1", "option"=>"asdfsafa", "_destroy"=>"false"}})
      end
      
      describe "should_receive methods" do 
        before do 
          @tag_list = []
          @question.stub(:tag_list).and_return(@tag_list)
          @tag_list.stub(:remove).with([]).and_return(true)
          @tag_list.stub(:add).with(["also"]).and_return(@tag_list)
        end

        it "should_receive tag_list" do 
          @question.should_receive(:tag_list).and_return(@tag_list)
        end

        it "should_receive add" do 
          @tag_list.should_receive(:add).with(["also"]).and_return(@tag_list)
        end

        after do 
          @question.save
        end
      end
        
      it "should create tags" do 
        @question.save!
        @question.tags.first.name.should eq("also")
      end
    end
  end

end