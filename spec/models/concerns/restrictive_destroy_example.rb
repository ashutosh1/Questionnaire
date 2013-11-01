shared_examples_for 'use restrictive destroy' do

  describe "before_destroy #destroyable?" do
    before do 
      @obj = described_class.create(name: "test")
    end

    context "questions not present" do 

      it "should return true" do 
        @obj.destroy.should eq(@obj)
      end

    end

    context "questions present" do 
      before do 
        @question.update_column(:question_level_id, @obj.id)
      end

      it "should return false" do 
        @obj.destroy.should eq(false)
      end

    end
  end

end