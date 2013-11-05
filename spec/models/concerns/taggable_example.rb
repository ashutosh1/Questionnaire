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
      @question = Question.create(question: "what is this?", question_type_id: @question_type.id, question_level_id: @question_level.id, user_id: @user.id)
    end

    describe "should_receive methods" do 
      it "should_receive add_tags" do 
        @question.should_receive(:add_tags)
        @question.save
      end
    end

    context "tags_field is blank" do 
    
      it "should return nil" do 
        @question.add_tags.should be_nil
      end

    end

    context "tags_field is present" do 
      before do 
        @question = Question.new(question: "what is this?", question_type_id: @question_type.id, question_level_id: @question_level.id, tags_field: "LapTop", user_id: @user.id)
      end
      
      describe "should_receive methods" do 
        before do 
          @tag_list = []
          @question.stub(:tag_list).and_return(@tag_list)
          @tag_list.stub(:add).with(["LapTop"]).and_return(@tag_list)
        end

        it "should_receive tag_list" do 
          @question.should_receive(:tag_list).and_return(@tag_list)
        end

        it "should_receive add" do 
          @tag_list.should_receive(:add).with(["LapTop"]).and_return(@tag_list)
        end

        after do 
          @question.save
        end
      end
        
      it "should create tags" do 
        @question.save!
        @question.tags.first.name.should eq("LapTop")
      end
    end
  end

  describe "#remove_tags" do
    before do 
      @question = Question.new(question: "what is this?", question_type_id: @question_type.id, question_level_id: @question_level.id, tags_field: "Lap", user_id: @user.id )
      @question.save
    end

    it "should remove the tag" do 
      old_tags_count = @question.tags.size
      @question.remove_tags(["Lap"])
      # @question.tags.reload.count.should eq(old_tags_count - 1)
    end
  end


end