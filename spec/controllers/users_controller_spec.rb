require 'spec_helper'
include ControllerHelper

describe UsersController do

  shared_examples_for 'call find_users' do
    describe "should_receive methods" do 
      
      it "should_not_receive authorize_resource" do 
        User.should_receive(:not_deleted).and_return(@users)
      end

      it "should_receive order" do 
        @users.should_receive(:order).with('created_at desc').and_return(@users)
      end

      after do 
        send_request
      end
    end

    it "should assign instance variable" do 
      send_request
      expect(assigns[:users]).to eq(@users)
    end
  end

  shared_examples_for 'call build_roles_users' do 
    describe "should_receive methods" do 
      it "should_receive roles_users" do 
        user.should_receive(:roles_users).twice.and_return([roles_user1])
      end

      it "Role should_receive where" do 
        Role.should_receive(:where).with(["id NOT IN (?)", [user.id]]).and_return([role2])
      end

      it "should_receive roles_users" do 
        role2.should_receive(:roles_users).and_return(roles_user2)
      end

      it "should_receive build" do 
        roles_user2.should_receive(:build).and_return(roles_user2)
      end

      after do 
        send_request
      end
    end

    it "should assign instance variable roles_users" do 
      send_request
      expect(assigns[:roles_users]).to eq([roles_user1, roles_user2])
    end

    context "user has no roles" do 
      before do 
        user.stub(:roles_users).and_return([])
        Role.stub(:where).with(["id NOT IN (?)", []]).and_return([])
        role1.stub(:roles_users).and_return(roles_user1)
        role2.stub(:roles_users).and_return(roles_user2)
      end
      describe "should_receive methods" do 

        it "Role should_receive all" do 
          Role.should_receive(:all).and_return([role1, role2])
        end

        it "role1 should_receive roles_users" do 
          role1.should_receive(:roles_users).and_return(roles_user1)
        end

        it "roles_user1 should_receive build" do 
          roles_user1.should_receive(:build).and_return(roles_user1)
        end

        it "role2 should_receive roles_users" do 
          role2.should_receive(:roles_users).and_return(roles_user2)
        end

        it "roles_user2 should_receive build" do 
          roles_user2.should_receive(:build).and_return(roles_user2)
        end

        after do 
          send_request
        end
      end

      it "should assign instance variable" do 
        send_request
        expect(assigns[:roles_users]).to eq([roles_user1, roles_user2])
      end
    end

    context "user has roles" do 
      it "Role should_not_receive all" do 
        Role.should_not_receive(:all)
      end

      it "role1 should_not_receive roles_users" do 
        role1.should_not_receive(:roles_users)
      end

      it "roles_user1 should_not_receive build" do 
        roles_user1.should_not_receive(:build)
      end

      after do 
        send_request
      end
    end
  end

  shared_examples_for "call find_users_and_build_roles" do
    it_should 'call build_roles_users'
    it_should 'call find_users'

    it "should render_template index" do 
      send_request
      response.should render_template "index"
    end
  end

  shared_examples_for "call before_action load_resource" do 
    it "User should_receive find" do 
      User.should_receive(:find).and_return(user)
      send_request
    end

    context "record found" do 
      it "should assign instance variable" do 
        send_request
        expect(assigns[:user]).to eq(user)
      end
    end

    context "record not found" do 
      before do 
        User.stub(:find).and_return(nil)
      end

      it "should raise exception" do 
        expect{ send_request }.to raise_exception
      end
    end


  end

  let(:user) { mock_model(User, save: true, id: 1, email: "ashutosh.tiwari@vinsol.com") }
  let(:user1) { mock_model(User, save: true, email: "test1@vinsol.com") }
  let(:role1) { mock_model(Role, save: true, id: 1, name: User::ROLES.first) }
  let(:role2) { mock_model(Role, save: true, id: 2, name: User::ROLES.last) }
  let(:roles_user1) { mock_model(RolesUser, save: true, id: 1, role_id: role1.id, user_id: user.id) }
  let(:roles_user2) { mock_model(RolesUser) }
  
  before do
    controller.stub(:current_user).and_return(user)
    @users = [user]
    @valid_attributes = { :email => "test@vinsol.com" }
    User.stub(:not_deleted).and_return(@users)
    @users.stub(:order).with('created_at desc').and_return(@users)
    User.stub(:new).and_return(user)
    user.stub(:roles_users).and_return([roles_user1])
    Role.stub(:where).with(["id NOT IN (?)", [user.id]]).and_return([role2])
    role2.stub(:roles_users).and_return(roles_user2)
    roles_user2.stub(:build).and_return(roles_user2)
    roles_user1.stub(:build).and_return(roles_user1)
    Role.stub(:all).and_return([role1, role2])
  end
  
  describe "index" do 
    def send_request
      get :index
    end
    
    it_should 'should_receive authorize_resource'
    it_should 'call build_roles_users'

    before do 
      should_authorize(:index, User)
      User.stub(:deleted).and_return(@users)
    end

    context "params[:type] deleted" do 
      def send_request
        get :index, type: 'deleted'
      end

      describe "should_receive methods" do 
        it "should_receive deleted" do 
          User.should_receive(:deleted).and_return(@users)
        end

        it "should_receive order" do 
          @users.should_receive(:order).with('created_at desc').and_return(@users)
        end

        after do 
          send_request
        end
      end

      it "should assign instance variable" do 
        send_request
        expect(assigns[:users]).to eq(@users)
      end

      it "should_not_receive find_users" do 
        controller.should_not_receive(:find_users)
        send_request
      end
    end

    context "params[:type] not deleted" do 
      it "should_receive find_users" do 
        controller.should_receive(:find_users)
        send_request
      end

      it_should 'call find_users'

    end
    
    it "should_receive new" do 
      User.should_receive(:new).and_return(user)
      send_request
    end

    it "should_receive build_roles_users" do 
      controller.should_receive(:build_roles_users)
      send_request
    end

    it "should assign instance variable" do 
      send_request
      expect(assigns[:user]).to eq(user)
    end

    it "should render template index" do 
      send_request
      response.should render_template 'index'
    end
  end

  describe "CREATE" do
    def send_request
      post :create, user: {email: "test@vinsol.com", roles: [role1.id]}
    end
    
    it_should 'should_receive authorize_resource'

    before do 
      should_authorize(:create, User)
      controller.stub(:params_user).and_return(@valid_attributes)
      User.stub(:new).and_return(user)
    end

    describe "should_receive methods" do 
      it "should_receive params_user" do 
        controller.should_receive(:params_user).and_return(@valid_attributes)
      end

      it "should_receive new" do 
        User.should_receive(:new).and_return(user)
      end

      it "should_receive save" do 
        user.should_receive(:save).and_return(true)
      end

      after do 
        send_request
      end
    end

    it "should assign instance variable" do 
      send_request
      expect(assigns[:user]).to eq(user)
    end

    context "user created" do 
      it "should have flash message" do 
        send_request
        flash[:notice].should eq("User created with email #{user.email}")
      end

      it "should redirect_to index" do 
        send_request
        response.should redirect_to users_path
      end
    end

    context "user not created" do 
      before do 
        user.stub(:save).and_return(false)
      end

      it "should not have flash message" do 
        send_request
        flash[:notice].should_not eq("User created with email #{user.email}")
      end

      it "should not redirect_to index" do 
        send_request
        response.should_not redirect_to users_path
      end

      it_should "call find_users_and_build_roles"

    end
  end

  describe "UPDATE" do 
    def send_request
      put :update, user: {email: "test@vinsol.com", roles: [role1.id]}, id: user.id
    end
    
    it_should 'should_receive authorize_resource'
    it_should 'call before_action load_resource' 

    before do 
      should_authorize(:update, user)
      controller.stub(:params_user).and_return(@valid_attributes)
      User.stub(:find).and_return(user)
      user.stub(:update_attributes).with(@valid_attributes).and_return(true)
    end

    it "should_receive params_user" do
      controller.should_receive(:params_user).and_return(@valid_attributes)
      send_request
    end

    it "should_receive update_attributes" do 
      user.should_receive(:update_attributes).with(@valid_attributes).and_return(true)
      send_request
    end

    context "user update" do 
      it "should have flash notice" do 
        send_request
        flash[:notice].should eq("User with email #{user.email} has been updated successfully")
      end

      it "should redirect_to index" do 
        send_request
        response.should redirect_to users_path
      end
    end

    context "user not update" do 
      before do 
        user.stub(:update_attributes).and_return(false)
      end

      it "should not have flash notice" do 
        send_request
        flash[:notice].should_not eq("User with email #{user.email} has been updated successfully")
      end
      
      it_should "call find_users_and_build_roles"

    end    
  end

  describe "DESTROY" do 
    def send_request
      delete :destroy, id: user.id
    end

    it_should 'should_receive authorize_resource'
    it_should 'call before_action load_resource' 

    before do 
      should_authorize(:destroy, user)
      User.stub(:find).and_return(user)
    end
    
    it "should_receive destroy" do 
      user.should_receive(:destroy).and_return(true)
      send_request
    end

    it "should redirect_to index" do 
      send_request
      response.should redirect_to users_path
    end

    context "record destroyed" do 
      before do 
        user.stub(:destroy).and_return(true)
        send_request
      end

      it "should have flash notice" do 
        flash[:notice].should eq("#{user.name} deleted successfully")
      end
    end

    context "record not destroyed" do 
      before do 
        user.stub(:destroy).and_return(false)
        send_request
      end

      it "should not have flash notice" do 
        flash[:notice].should_not eq("#{user.name} deleted successfully")
      end

      it "should have a flash alert" do 
        flash[:alert].should eq("#{user.name} could not deleted")
      end
    end
  end

  describe "SHOW" do 
    def send_request
      xhr :get, :show, id: user.id
    end

    it_should 'should_receive authorize_resource'
    it_should 'call before_action load_resource' 

    before do 
      should_authorize(:show, user)
      User.stub(:find).and_return(user)
      request.env["HTTP_REFERER"] = users_path
    end

    it "should render_template show" do 
      send_request
      response.should render_template "show"
    end
    
    context "xhr request" do 
      it "should not redirect_to referrer" do 
        send_request
        response.should_not redirect_to users_path
      end

      context "user is current_user" do 
        before do 
          controller.stub(:current_user).and_return(user)
        end

        it "should have a flash alert" do 
          send_request
          flash[:alert].should eq("You can not edit your roles")
        end

        it "should_not_receive build_roles_users" do 
          controller.should_not_receive(:build_roles_users)
          send_request
        end
      end

      context "user is not current_user" do 
        before do 
          controller.stub(:current_user).and_return(user1)
        end

        it "should not have a flash alert" do 
          send_request
          flash[:alert].should_not eq("You can not edit your roles")
        end

        it_should "call build_roles_users"

      end
    end

    context "html request" do 
      it "should redirect_to referrer" do 
        get :show, id: user.id
        response.should redirect_to users_path
      end
    end
  end

  describe "params_user" do
    def send_request
      post :create, user: {name: 'Sideshow', email: 'abc@vinsol.com',
        roles_users_attributes: {"0"=>{"role_id"=>"1", "_destroy"=>"0"} }       
       }
    end

    before do 
      should_authorize(:create, User)
    end

    it 'should_receive with email only' do
      User.should_receive(:new).with({email: 'abc@vinsol.com'}.with_indifferent_access)
      post :create, user: { first_name: 'Sideshow', last_name: 'Bob', email: 'abc@vinsol.com' }
    end
   
    it "should_receive email and role_users_attributes only" do 
      User.should_receive(:new).with({email: 'abc@vinsol.com', roles_users_attributes: {"0"=>{"role_id"=>"1", "_destroy"=>"0"}}}.with_indifferent_access)
      send_request
    end

    it "new should_not_receive params_user with name" do 
      User.should_not_receive(:new).with({name: 'Sideshow', email: 'abc@vinsol.com', roles_users_attributes: {"0"=>{"role_id"=>"1", "_destroy"=>"0"}}}.with_indifferent_access)
      send_request
    end
  end
end
