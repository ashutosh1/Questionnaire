require 'spec_helper'
include ControllerHelper

describe HomeController do

  shared_examples_for 'skip_authorize_resource for HomeController' do
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

  describe "INDEX" do 
    def send_request
      get :index
    end
    
    it_should 'skip_authorize_resource for HomeController'

    it "should render template index" do 
      send_request
      response.should render_template 'index'
    end
  end

end
