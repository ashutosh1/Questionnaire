shared_examples_for 'find for google oauth verification' do

  describe ".find_for_google_oauth2" do 
    before do 
      @auth = 
      {
        :provider => "google_oauth2",
        :uid => "123456789",
        :info => {
          :name => "ashutosh tiwari",
          :email => "ashutosh.tiwari@vinsol.com",
        }
      }
    end

    context "user present in db with all auth info" do 
      before do 
        @user.update_attributes(name: "ashutosh tiwari", provider: "google_oauth2", uid: "123456789")
      end

      it "should return user" do 
        User.find_for_google_oauth2(@auth).should eq(@user)
      end

      describe "should_receive methods" do 
        before do 
          User.stub(:where).with(email: @auth[:info][:email], name: @auth[:info][:name], provider: @auth[:provider], uid: @auth[:uid]).and_return([@user])
        end

        it "should_receive where" do 
          User.should_receive(:where).with(email: @auth[:info][:email], name: @auth[:info][:name], provider: @auth[:provider], uid: @auth[:uid]).and_return([@user])
          User.find_for_google_oauth2(@auth)
        end
      end
    end

    context "user present in db with auth email" do
      it "should return user" do 
        User.find_for_google_oauth2(@auth).should eq(@user)
      end

      it "should update users name, provider and uid with auth info" do 
        User.find_for_google_oauth2(@auth)
        @user.reload
        @user.name.should eq(@auth[:info][:name])
        @user.uid.should eq(@auth[:uid])
        @user.provider.should eq(@auth[:provider])
      end

      describe "should_receive methods" do 
        before do 
          User.stub(:where).with(email: @auth[:info][:email], name: @auth[:info][:name], provider: @auth[:provider], uid: @auth[:uid]).and_return([])
          User.stub(:where).with(email: @auth[:info][:email]).and_return([@user])
          @user.stub(:update_attributes).with(name: @auth[:info][:name], provider: @auth[:provider], uid: @auth[:uid] ).and_return(true)
        end

        it "should_receive where" do 
          User.should_receive(:where).with(email: @auth[:info][:email], name: @auth[:info][:name], provider: @auth[:provider], uid: @auth[:uid]).and_return([])
        end

        it "should_receive where" do 
          User.should_receive(:where).with(email: @auth[:info][:email]).and_return([@user])
        end

        it "should_receive update_attributes" do 
          @user.should_receive(:update_attributes).with(name: @auth[:info][:name], provider: @auth[:provider], uid: @auth[:uid] ).and_return(true)
        end

        after do 
          User.find_for_google_oauth2(@auth)
        end
      end
    end

    context "user not present" do 
      before do 
        @user1 = User.create(:email => "test@vinsol.com")
        @user.delete
      end

      it "should return nil" do 
        User.find_for_google_oauth2(@auth).should be_nil
      end

      describe "should_receive methods" do 
        before do 
          User.stub(:where).with(email: @auth[:info][:email], name: @auth[:info][:name], provider: @auth[:provider], uid: @auth[:uid]).and_return([])
          User.stub(:where).with(email: @auth[:info][:email]).and_return([])
        end

        it "should_receive where" do 
          User.should_receive(:where).with(email: @auth[:info][:email], name: @auth[:info][:name], provider: @auth[:provider], uid: @auth[:uid]).and_return([])
        end

        it "should_receive where" do 
          User.should_receive(:where).with(email: @auth[:info][:email]).and_return([])
        end

        after do 
          User.find_for_google_oauth2(@auth)
        end
      end
    end
  end

end