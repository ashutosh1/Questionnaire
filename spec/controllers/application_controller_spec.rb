require "spec_helper"

describe ApplicationController do
  let(:user) { mock_model(User, :save => true, email: "ashutosh.tiwari@vinsol.com") }
  
  before do
    controller.stub(:current_user).and_return(user)
  end

  controller do
    before_filter :set_current_user

    def index
      render :nothing => true
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


end