shared_examples_for 'send email to user after creation' do

  describe "after_create #send_account_creation_mail" do 
    before do 
      @user1 = User.new(email: "test@vinsol.com")
      Thread.current[:audited_admin] = @user
    end

    describe "should receive methods" do
      before do 
        UserMailer.stub(:delay).and_return(UserMailer)
        UserMailer.stub(:send_account_creation_mail).with(@user1, @user)
      end 

      it "should receive delay" do 
        UserMailer.should_receive(:delay).and_return(UserMailer)
      end

      it "should_receive send_account_creation_mail" do
        UserMailer.should_receive(:send_account_creation_mail).with(@user1, @user)
      end

      after do
        @user1.save
      end
    end

    it "should insert into delayed job" do 
      count = Delayed::Job.count
      @user1.save
      Delayed::Job.count.should eq(count + 1)
    end
  end

end