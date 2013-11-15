require "spec_helper"

describe ApplicationController do
  let(:user) { mock_model(User, :save => true, email: "ashutosh.tiwari@vinsol.com") }
  
  before do
    controller.stub(:current_user).and_return(user)
  end

  controller do
    before_filter :set_current_user

    def index
      raise CanCan::AccessDenied
    end

    def show
      raise ActionController::RedirectBackError 
    end

    def update
      raise ActiveRecord::RecordNotFound
    end
  end
  
  describe "before_filter set_current_user" do 
    def send_request
      get :index
    end

    describe "should_receive methods" do 

      it "should_receive set_current_user" do 
        controller.should_receive(:set_current_user)
        send_request
      end

      it "should set the admin" do 
        send_request
        Thread.current[:audited_admin].should eq(user)
      end

      it "should set request ip" do 
        send_request
        Thread.current[:ip].should eq(request.try(:ip))
      end
    end
  end

  describe "rescue_from CanCan::AccessDenied" do 
    def send_request
      get :index
    end

    it "should redirect_to root_url" do 
      send_request
      response.should redirect_to root_url
    end

    it "should throw exception message" do 
      send_request
      flash[:alert].should eq("You are not authorized to access this page.")
    end
  end

  describe "rescue_from ActionController::RedirectBackError " do 
    def send_request
      get :show, id: "abc"
    end

    it "should redirect_to root_url" do 
      send_request
      response.should redirect_to root_url
    end

    it "should throw exception message" do 
      send_request
      flash[:alert].should eq("No HTTP_REFERER was set in the request to this action, so redirect_to :back could not be called successfully. If this is a test, make sure to specify request.env[\"HTTP_REFERER\"].")
    end
  end

  describe "rescue_from ActiveRecord::RecordNotFound" do 
    def send_request
      get :update, id: "abc"
    end

    it "should redirect_to root_url" do 
      send_request
      response.should redirect_to root_url
    end

    it "should throw exception message" do 
      send_request
      flash[:alert].should eq("ActiveRecord::RecordNotFound")
    end
  end



end