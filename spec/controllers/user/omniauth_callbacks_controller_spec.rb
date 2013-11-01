require 'spec_helper'

describe Users::OmniauthCallbacksController do

  shared_examples_for 'call before_action find_user_with_google_data' do
    describe "should_receive methods" do 
      it "should_receive find_for_google_oauth2" do 
        User.should_receive(:find_for_google_oauth2).with(@auth, nil).and_return(user)
        send_request
      end
    end

    describe "assigns instance variable" do 
      it "should assign user" do 
        send_request
        expect(assigns[:user]).to eq(user)
      end
    end

    context "user present" do 
      it "should not have flash alert" do 
        send_request
        flash[:alert].should_not eq("You are not authorize to login")
      end
    end

    context "user not present" do 
      before do 
        User.stub(:find_for_google_oauth2).with(@auth, nil).and_return(nil)
        send_request
      end

      it "should have flash alert" do 
        flash[:alert].should eq("You are not authorize to login")
      end

      it "should redirect_to root_url" do 
        response.should redirect_to root_url
      end
    end
  end

  shared_examples_for 'skip_authorize_resource for OmniauthCallbacksController' do
    describe "should_receive methods" do 
      
      it "should_not_receive authorize_resource" do 
        controller.should_not_receive(:authorize_resource)
      end

      it "should_not_receive authorize!" do 
        controller.should_not_receive(:authorize!)
      end
      after do 
        send_request
      end
    end
  end


  let(:user) { mock_model(User, save: true, id: 1, email: "ashutosh.tiwari@vinsol.com") }
  
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user.stub(:authenticatable_salt).and_return(true)
  end
  
  describe "google_oauth2" do 
    def send_request
      get :google_oauth2
    end

    before do 
      @auth = {:provider => "google_oauth2", :uid => "123456789", :info => {:name => "ashutosh tiwari", :email => "ashutosh.tiwari@vinsol.com" }}
      request.env["omniauth.auth"] = @auth
      User.stub(:find_for_google_oauth2).with(@auth, nil).and_return(user)
    end
    
    it_should 'skip_authorize_resource for OmniauthCallbacksController'
    it_should "call before_action find_user_with_google_data"

    it "should have a flash notice" do 
      send_request
      flash[:notice].should eq("signed in successfully")
    end
    
    it "should set current_user" do 
      send_request
      controller.current_user.should eq(user)
    end

    it "should redirect_to root_url" do 
      send_request
      response.should redirect_to root_url
    end
  end

end
