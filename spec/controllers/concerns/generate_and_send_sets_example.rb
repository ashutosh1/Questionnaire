shared_examples_for 'use generate_and_send_sets' do
  describe "generate_and_send_sets" do 
    before do 
      @file_name = "file_name.zip"
      test_set.stub(:generate_different_sets).with(2).and_return(true)
      test_set.stub(:file_name).and_return("file_name")
      File.stub(:new).with((Rails.root.join("public/reports/#{@test_set.file_name}.zip")).and_return(@file_name)
      @file_name.stub(:read).and_return(@file_name)
      controller.stub(:send_data).with(@file_name, :type=>"application/zip" , :filename => @file_name)).and_return(true)
      File.stub(:delete).with(Rails.root.to_s + "/public/reports/#{@test_set.file_name}.zip").and_return(true)
    end
    
    describe "should_receive methods" do 
      it "should_receive generate_different_sets" do 
        test_set.should_receive(:generate_different_sets).with(2).and_return(true)
      end

      it "should_receive file_name" do 
        test_set.should_receive(:file_name).and_return("file_name")
      end

      it "should_receive new" do 
        File.should_receive(:new).with((Rails.root.join("public/reports/#{@test_set.file_name}.zip")).and_return(@file_name)
      end

      it "should_receive read" do 
        @file_name.should_receive(:read).and_return(@file_name)
      end

      it "should_receive send_data" do 
        controller.should_receive(:send_data).with(@file_name, :type=>"application/zip" , :filename => @file_name)).and_return(true)
      end

      it "should_receive delete" do 
        File.should_receive(:delete).with(Rails.root.to_s + "/public/reports/#{@test_set.file_name}.zip").and_return(true)
      end

      after do 
        send_request
      end
    end
  end

end
