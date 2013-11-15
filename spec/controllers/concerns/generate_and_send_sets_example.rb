shared_examples_for 'use generate_and_send_sets module' do
  describe "generate_and_send_sets" do 
    
    describe "should_receive methods" do 
      it "should_receive generate_different_sets" do 
        test_set.should_receive(:generate_different_sets)
      end

      it "should_receive file_name" do 
        test_set.should_receive(:file_name).and_return("file_name")
      end

      it "should_receive new" do 
        File.should_receive(:new).and_return(@file)
      end

      it "should_receive read" do 
        @file.should_receive(:read).and_return(@file)
      end
      
      #TODO its trying to render respective html file
      # it "should_receive send_data" do 
      #   controller.should_receive(:send_data).with(@file, :type=>"application/zip", :disposition=>"attachment", :filename => "file_name.zip").and_return(true)
      # end

      it "should_receive delete" do 
        File.should_receive(:delete).with(Rails.root.to_s + "/public/reports/#{test_set.file_name}.zip").and_return(true)
      end

      after do 
        send_request
      end
    end
  end

end
