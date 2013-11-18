shared_examples_for 'generate sets and doc' do
  before do 
    @test_set.stub(:questions).and_return(@questions)
    @questions.stub(:includes).with(:options).and_return(@questions)
    @document = RTF::Document.new(RTF::Font.new(RTF::Font::ROMAN, 'Times New Roman'))
    RTF::Document.stub(:new).and_return(@document)
    @test_set.stub(:generate_set_answer).with(@document, 0, @questions).and_return(@document)  
    @test_set.stub(:generate_set).with(@document, 0, @questions).and_return(@document)
  end
  
  describe "should_receive methods" do 
    it "should_receive questions" do 
      @test_set.should_receive(:questions).and_return(@questions)
    end

    it "should_receive includes" do 
      @questions.should_receive(:includes).with(:options).and_return(@questions)
    end

    it "should_receive shuffle" do 
      @questions.should_receive(:shuffle).and_return(@questions)
    end
    
    it "should_receive new" do 
      RTF::Font.should_receive(:new).and_return(@font_style)
    end

    it "RTF::Document should_receive new"  do
      RTF::Document.should_receive(:new).and_return(@document)  
    end

    it "should_receive generate_set" do 
      @test_set.should_receive(:generate_set).with(@document, 0, @questions).and_return(@document)  
    end

    it "should_receive page brake" do 
      @document.should_receive(:page_break).and_return(true)
    end

    it "should_receive generate_set_answer" do 
      @test_set.should_receive(:generate_set_answer).with(@document, 0, @questions).and_return(@document)  
    end

    it "should_receive compress_all_sets_together" do 
      @test_set.should_receive(:compress_all_sets_together)
    end

    it "should_receive open" do 
      @document.should_receive(:to_rtf)
    end

    it "should_receive open and yild a block" do 
      expect {|b| File.open(1, 'w', &b) }.to yield_control
    end
    
    after do 
      @test_set.generate_different_sets(1)
      File.delete(Rails.root.to_s + "/public/reports/#{@test_set.file_name}.zip") if File.exist?(Rails.root.to_s + "/public/reports/#{@test_set.file_name}.zip")
    end
  end
  
  describe "generate_set_answer" do 
    it "should yield_control" do 
      expect {|b| @document.paragraph(&b) }.to yield_control
      @test_set.generate_set_answer(@document, 0, @questions)
    end
  end

  describe "generate_set" do 
    it "should yield_control" do 
      expect {|b| @document.paragraph(&b) }.to yield_control
      @test_set.generate_set(@document, 0, @questions)
    end
  end


  describe "compress_all_sets_together" do
    before do 
      @zipfile_name = "public/reports/#{@test_set.file_name}.zip"
      @f = "public/reports/demo_test.zip"
    end 

    it "should_receive open" do 
      expect {|b| Zip::File.open(@zipfile_name, Zip::File::CREATE, &b) }.to yield_control
    end

    it "should delete directory" do 
      File.exist?(Rails.root.to_s + "/public/reports/#{@test_set.file_name}").should eq(false)
    end

    after do 
      @test_set.compress_all_sets_together
      File.delete(Rails.root.to_s + "/public/reports/#{@test_set.file_name}.zip") if File.exist?(Rails.root.to_s + "/public/reports/#{@test_set.file_name}.zip")
    end
  end
end
