shared_examples_for 'use search questions module' do
  before do 
    @query = {"category"=>"geography,", "tags"=>"also,", "query"=>{"Subjective"=>{"number_of_questions"=>"1", "levels"=>{"1"=>{"number_of_questions"=>"1"}}}, "Mcq"=>{"number_of_questions"=>"", "levels"=>{"1"=>{"number_of_questions"=>""}, "2"=>{"number_of_questions"=>""}, "3"=>{"number_of_questions"=>""}}}, "Mcqma"=>{"number_of_questions"=>"", "levels"=>{"1"=>{"number_of_questions"=>""}, "2"=>{"number_of_questions"=>""}, "3"=>{"number_of_questions"=>""}}}}}
    @query_wih_zero_num_of_question = {"category"=>"geography,", "tags"=>"also,", "query"=>{"Subjective"=>{"number_of_questions"=>"", "levels"=>{""=>{"number_of_questions"=>"1"}}}, "Mcq"=>{"number_of_questions"=>"", "levels"=>{"1"=>{"number_of_questions"=>""}, "2"=>{"number_of_questions"=>""}, "3"=>{"number_of_questions"=>""}}}, "Mcqma"=>{"number_of_questions"=>"", "levels"=>{"1"=>{"number_of_questions"=>""}, "2"=>{"number_of_questions"=>""}, "3"=>{"number_of_questions"=>""}}}}}
    @query_rand = {"category"=>"geography,", "tags"=>"also,", "query"=>{"Subjective"=>{"number_of_questions"=>"1", "random"=>"true", "levels"=>{"1"=>{"number_of_questions"=>""}, "2"=>{"number_of_questions"=>""}, "3"=>{"number_of_questions"=>""}}}, "Mcq"=>{"number_of_questions"=>"", "levels"=>{"1"=>{"number_of_questions"=>""}, "2"=>{"number_of_questions"=>""}, "3"=>{"number_of_questions"=>""}}}, "Mcqma"=>{"number_of_questions"=>"", "levels"=>{"1"=>{"number_of_questions"=>""}, "2"=>{"number_of_questions"=>""}, "3"=>{"number_of_questions"=>""}}}}}
    @question_types = ["Subjective"]   
    @categories = "geography,"
    @tags = "also,"
    @conditions = ["1 AND categories.name in (?) AND tags.name in (?) AND type = ?", @category.name, "also", "Subjective"]
  end

  describe ".get_questions" do 
    before do
      described_class.stub(:search_conditions).and_return(@conditions)
      @num_of_questions_for_type = @query["query"]["Subjective"]["number_of_questions"].to_i
    end

    it "should receive search_conditions" do 
      described_class.should_receive(:search_conditions).with(@categories, @tags, "Subjective").and_return(@conditions)
      described_class.get_questions(@question_types, @query["query"], @categories, @tags)
    end
    
    context "select random" do 
      before do 
        described_class.stub(:search_all_questions).and_return(@questions)
      end

      it "should_receive search_all_questions" do 
        described_class.should_receive(:search_all_questions).and_return(@questions)
        described_class.get_questions(@question_types, @query_rand["query"], @categories, @tags)
      end

      context "number of question is sort" do 
        before do 
          described_class.stub(:search_all_questions).and_return([])  
        end

        it "should have a error message" do 
          result, error = described_class.get_questions(@question_types, @query_rand["query"], @categories, @tags)
          error.should eq({"Subjective"=>"You have selected 1 questions for Subjective but found only 0\n"})
        end
      end

      context "number of question is not sort" do 
        it "should not have a error message" do 
          result, error = described_class.get_questions(@question_types, @query_rand["query"], @categories, @tags)
          error.should be_blank
        end
      end
    end

    context "select by level" do 
      before do 
        @num_of_questions_for_levels = 1
      end

      it "should_receive search_conditions with level id" do 
        described_class.should_receive(:search_conditions).and_return(@conditions)
        described_class.get_questions(@question_types, @query["query"], @categories, @tags)
      end

      context "number_of_questions present" do 
        it "should_receive search_all_questions" do 
          described_class.should_receive(:search_all_questions).and_return(@questions)  
          described_class.get_questions(@question_types, @query["query"], @categories, @tags)  
        end

        context "number of question is sort" do 
          before do 
            described_class.stub(:search_all_questions).and_return([])  
          end

          it "should have a error message" do 
            result, error = described_class.get_questions(@question_types, @query["query"], @categories, @tags)
            error["1"].should eq("You have selected 1 questions for  under Subjective but found only 0")
          end
        end

        context "number of question is not sort" do 
          before do 
            described_class.stub(:search_all_questions).and_return(@questions)  
          end

          it "should not have a error message" do 
            result, error = described_class.get_questions(@question_types, @query["query"], @categories, @tags)
            error.should be_blank
          end
        end
      end

      context "number_of_questions not present" do 
        it "should_not_receive search_all_questions" do 
          described_class.should_receive(:search_all_questions).once.and_return(@questions)
          described_class.get_questions(@question_types, @query_wih_zero_num_of_question["query"], @categories, @tags)  
        end

        it "should not have a error message" do 
          result, error = described_class.get_questions(@question_types, @query_wih_zero_num_of_question["query"], @categories, @tags)  
          error.should be_blank
        end
      end
    end
  end

  describe ".search_all_questions" do 
    before do 
      Question.stub(:published).and_return(@questions)
      @questions.stub(:joins).with(:categories, :tags).and_return(@questions)
      @questions.stub(:where).with(@conditions).and_return(@questions)
      @questions.stub(:random).with(2).and_return(@questions)
      @questions.stub(:uniq).and_return(@questions)
    end

    describe "should_receive methods" do 
      it "should_receive published" do 
        Question.should_receive(:published).and_return(@questions)
      end

      it "should_receive joins" do 
        @questions.should_receive(:joins).with(:categories, :tags).and_return(@questions)
      end

      it "should_receive where" do 
        @questions.should_receive(:where).with(@conditions).and_return(@questions)
      end

      it "should_receive random" do 
        @questions.should_receive(:random).with(2).and_return(@questions)
      end

      it "should_receive uniq" do 
        @questions.should_receive(:uniq).and_return(@questions)
      end

      after do 
        described_class.search_all_questions(@conditions, 2)
      end
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