shared_examples_for 'use category restrictive destroy' do

  describe "before_destroy #destroyable?" do
    before do 
      Question.any_instance.stub(:sub_options_and_answer).and_return(true)
      @obj = described_class.create(name: "test")
    end
    
    context "questions present" do 
      before do 
        @obj.stub(:questions).and_return(@question)
      end

      it "should return false" do 
        @obj.destroy.should eq(false)
      end
    end

    context "questions not present" do 
      before do 
        @obj.children.create(name: "math")
      end

      context "sub category has questions" do 
        before do 
          @obj.stub(:questions).and_return(@question)
        end

        it "should return false" do 
          @obj.destroy.should eq(false)
        end
      end

      context "sub category has no question" do 
        it "should return destroy" do 
          @obj.destroy.should eq(@obj)
        end
      end
    end
  end

end