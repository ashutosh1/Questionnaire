shared_examples_for 'use search questions module' do
  before do 
    @query = {"category"=>"geography,", "tags"=>"also,", "query"=>{"Subjective"=>{"number_of_questions"=>"", "levels"=>{"1"=>{"number_of_questions"=>""}, "2"=>{"number_of_questions"=>""}, "3"=>{"number_of_questions"=>""}}}, "Mcq"=>{"number_of_questions"=>"", "levels"=>{"1"=>{"number_of_questions"=>""}, "2"=>{"number_of_questions"=>""}, "3"=>{"number_of_questions"=>""}}}, "Mcqma"=>{"number_of_questions"=>"", "levels"=>{"1"=>{"number_of_questions"=>""}, "2"=>{"number_of_questions"=>""}, "3"=>{"number_of_questions"=>""}}}}}
    @question_types = ["Subjective"]   
    @categories = "geography,"
    @tags = "also,"
  end

  describe ".get_questions" do 
    before do 
    end
    it "should receive search_conditions" do 
      described_class.should_receive(:search_conditions).with(@categories, @tags, "Subjective").and_return(["1 AND categories.name in (?) AND tags.name in (?) AND type = ?", "geography", "also", "Subjective"])
      described_class.get_questions(@question_types, @query[:query], @categories, @tags)
    end

  end
  
  describe ".level_name" do 
    it "should return name of question level" do 
      described_class.level_name(@ql1.id).should eq(@ql1.name)
    end
  end

  describe ".serach_conditions" do 
    context "category, tag and type present" do 
      it "should eq to name query" do 
        described_class.search_conditions("#{@category.name},", "also,", "Subjective").should eq(["1 AND categories.name in (?) AND tags.name in (?) AND type = ?", @category.name, "also", "Subjective"])
      end
    end

    context "category, tag, type and level present" do 
      it "should eq to name query" do 
        described_class.search_conditions("#{@category.name},", "also,", "Subjective", "avg").should eq(["1 AND categories.name in (?) AND tags.name in (?) AND type = ? AND question_level_id = ?", "test", "also", "Subjective", "avg"])
      end
    end
  end

end