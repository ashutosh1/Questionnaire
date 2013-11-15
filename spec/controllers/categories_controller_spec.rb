require 'spec_helper'
include ControllerHelper

describe CategoriesController do
  shared_examples_for "call before_action load_resource for categories" do 

    it "Category should_receive find" do 
      Category.should_receive(:find).and_return(category2)
      send_request
    end

    context "record found" do 
      it "should assign instance variable" do 
        send_request
        expect(assigns[:category]).to eq(category2)
      end
    end

    context "record not found" do 
      before do 
        Category.stub(:find).and_return(nil)
      end

      it "should raise exception" do 
        expect{ send_request }.to raise_exception
      end
    end

  end

  shared_examples_for "call before_action find_parent_and_initialize" do 
    context "params[:category][:parent] blank" do 
      def send_request
        post :create,  category: {name: "asfas", parent: ""}
      end

      it "should_receive roots" do 
        Category.should_receive(:roots).and_return(@roots)
        send_request
      end

      it "should_receive build" do 
        @roots.should_receive(:build).with(@valid_attributes).and_return(category)
        send_request
      end

      it "should assigns instance variable" do 
        send_request
        expect(assigns[:category]).to eq(category)
      end

    end

    context "params[:category][:parent] present" do 
      it "should_receive where" do 
        Category.should_receive(:where).with(id: category.id.to_s).and_return(@categories)
        send_request
      end

      it "should_receive children" do 
        category.should_receive(:children).and_return(category2)
        send_request
      end

      it "should_receive build" do 
        category2.should_receive(:build).with(@valid_attributes).and_return(category2)
        send_request
      end

      it "should assigns instance variable" do 
        send_request
        expect(assigns[:category]).to eq(category2)
      end
    end
  end

  let(:user) { mock_model(User, save: true, id: 1, email: "ashutosh.tiwari@vinsol.com") }
  let(:role) { mock_model(Role, save: true, id: 1, name: User::ROLES.first) }
  let(:roles_user) { mock_model(RolesUser, save: true, id: 1, role_id: role1.id, user_id: user.id) }
  let(:category) {mock_model(Category, save: true, id: 1, name: 'category1')}
  let(:category) {mock_model(Category, save: true, id: 1, name: 'category1')}
  let(:question_level) {mock_model(QuestionLevel, save: true, id: 2, name: 'beginner')}
  let(:question) { mock_model(Question, save: true, question: "What is sql?", question_level_id: question_level.id, user_id: user.id, type: 'Subjective', tags_field: "also", category_field: "#{category.id}", "options_attributes"=>{"1384334256874"=>{"answer"=>"1", "option"=>"asdfsafa", "_destroy"=>"false"}}) }
  let(:category2) {mock_model(Category, save: true, id: 2, name: 'category2', ancestry: "1/2")}

  before do
    controller.stub(:current_user).and_return(user)
    @questions = [question]
    @categories = [category]
    @roots = [category]
    @children = [category2]
    @valid_attributes = {name: "demo"}
  end

  describe "index" do 
    def send_request
      get :index
    end
    
    it_should 'should_receive authorize_resource'

    before do 
      should_authorize(:index, Category)
      Category.stub(:new).and_return(category)
      Category.stub(:roots).and_return(@roots)
      category.stub(:to_node).and_return(category)
    end

    it "should_receive new" do 
      Category.should_receive(:new).and_return(category)
      send_request
    end

    it "should assign instance variable" do
      send_request 
      expect(assigns[:category]).to eq(category)
    end

    context "html request" do
      it "should render_template index" do 
        send_request
        response.should render_template "index"
      end

      it "should_not_receive roots" do 
        Category.should_not_receive(:roots)
        send_request
      end

      it "should_not_receive to_node" do 
        category.should_not_receive(:to_node)
        send_request
      end
    end

    context "xhr request" do 
      def send_request
        xhr :get, :index
      end

      it "should_receive roots" do 
        Category.should_receive(:roots).and_return(@roots)
        send_request
      end

      it "should_receive to_node" do 
        category.should_receive(:to_node).and_return(category)
        send_request
      end
    end

  end


  describe "CREATE" do 
    def send_request
      post :create, category: {name: "set", parent: category.id}
    end
    
    it_should 'should_receive authorize_resource'
    it_should "call before_action find_parent_and_initialize"

    before do 
      should_authorize(:create, category)
      should_authorize(:create, category2)
      controller.stub(:params_category).and_return(@valid_attributes)
      Category.stub(:roots).and_return(@roots)
      @roots.stub(:build).with(@valid_attributes).and_return(category)
      Category.stub(:where).with(id: category.id.to_s).and_return(@categories)
      category.stub(:children).and_return(category2)
      category2.stub(:build).with(@valid_attributes).and_return(category2)
    end

    it "should_receive save" do 
      category2.should_receive(:save).and_return(true)
      send_request
    end

    context "category created" do 
      it "should redirect_to index" do 
        send_request
        response.should redirect_to categories_path
      end

      it "should have a flash notice" do 
        send_request
        flash[:notice].should eq("#{category2.name} has been created successfully")
      end
    end

    context "category not created" do 
      before do 
        category2.stub(:save).and_return(false)  
      end

      it "should render_template index" do 
        send_request
        response.should render_template 'index'
      end

      it "should not have a flash notice" do 
        send_request
        flash[:notice].should_not eq("#{category2.name} has been created successfully")
      end
    end
  end

  describe "UPDATE" do 
    def send_request
      xhr :put, :update, target_node: category.id, id: category2.id
    end
    
    it_should 'should_receive authorize_resource'
    it_should "call before_action load_resource for categories"

    before do 
      should_authorize(:update, category2)
      Category.stub(:find).and_return(category2)
      category2.stub(:update_values).and_return(true)
    end

    it "should_receive find" do 
      Category.should_receive(:find).and_return(category2)
      send_request
    end

    it "should_receive update_value" do 
      category2.should_receive(:update_values).and_return(true)
      send_request
    end

    it "should render_template update" do 
      send_request
      response.should render_template "update"
    end

    context "record updated" do 
      it "should have a flash notice" do 
        send_request
        flash[:notice].should eq("#{category2.name} has been updated successfully")
      end
    end

    context "record not updated" do 
      before do 
        category2.stub(:update_values).and_return(false)        
      end

      it "should have a flash alert" do 
        send_request
        flash[:alert].should eq("#{category2.name} could not be updated")
      end
    end
  
  end

  describe "DESTROY" do 
    def send_request
      delete :destroy, id: category2.id
    end
    
    it_should 'should_receive authorize_resource'
    it_should "call before_action load_resource for categories"

    before do 
      should_authorize(:destroy, category2)
      Category.stub(:find).and_return(category2)
      category2.stub(:destroy).and_return(true)
    end

    it "should_receive find" do 
      Category.should_receive(:find).and_return(category2)
      send_request
    end

    it "should_receive destroy" do 
      category2.should_receive(:destroy).and_return(true)
      send_request
    end

    context "record destroyed" do 
      it "should have a flash notice" do 
        send_request
        flash[:notice].should eq("#{category2.name} has been deleted successfully")
      end

      it "should redirect_to index" do 
        send_request
        response.should redirect_to categories_path
      end
    end

    context "record not updated" do 
      before do 
        category2.stub(:destroy).and_return(false)
      end

      it "should have a flash notice" do 
        send_request
        flash[:alert].should eq("#{category2.name} could not be deleted, please remove associated questions.")
      end

      it "should redirect_to index" do 
        send_request
        response.should redirect_to categories_path
      end
    end
  end

  describe "params_category" do
   def send_request
      post :create, category: {name: "demo", parent: category.id}
    end
    
    it_should 'should_receive authorize_resource'

    before do 
      should_authorize(:create, category)
      should_authorize(:create, category2)
      Category.stub(:roots).and_return(@roots)
      @roots.stub(:build).with(@valid_attributes).and_return(category)
      Category.stub(:where).with(id: category.id.to_s).and_return(@categories)
      category.stub(:children).and_return(category2)
      category2.stub(:build).with("name"=>"demo").and_return(category2)
    end

    it 'should_receive build with' do
      category2.should_receive(:build).with({name: "demo"}.with_indifferent_access).and_return(category)
      send_request
    end
  end


end