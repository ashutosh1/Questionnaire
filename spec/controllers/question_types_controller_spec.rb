require 'spec_helper'
include ControllerHelper

describe QuestionTypesController do

  shared_examples_for "call before_action find_question_types" do 
    it "should_receive order" do 
      QuestionType.should_receive(:order).with('created_at desc').and_return(@question_types)
      send_request
    end
  
    it "should assigns instance variable" do 
      send_request
      expect(assigns[:question_types]).to eq(@question_types)
    end
  end

  shared_examples_for "call before_action load_resource for question type" do 

    it "QuestionType should_receive find" do 
      QuestionType.should_receive(:find).and_return(question_type)
      send_request
    end

    context "record found" do 
      it "should assign instance variable" do 
        send_request
        expect(assigns[:question_type]).to eq(question_type)
      end
    end

    context "record not found" do 
      before do 
        QuestionType.stub(:find).and_return(nil)
      end

      it "should raise exception" do 
        expect{ send_request }.to raise_exception
      end
    end

  end


  let(:user) { mock_model(User, save: true, id: 1, email: "ashutosh.tiwari@vinsol.com") }
  let(:role) { mock_model(Role, save: true, id: 1, name: User::ROLES.first) }
  let(:roles_user) { mock_model(RolesUser, save: true, id: 1, role_id: role1.id, user_id: user.id) }
  let(:category) {mock_model(Category, save: true, id: 1, name: 'category')}
  let(:question_type) {mock_model(QuestionType, save: true, id: 1, name: 'mcq')}
  let(:question_level) {mock_model(Category, save: true, id: 2, name: 'beginner')}
  let(:question) { mock_model(Question, save: true, id: 1, question: "what is sql?", question_type_id: question_type.id, question_level_id: question_level.id, user_id: user.id) }
  let(:categories_question) {mock_model(CategoriesQuestion, save: true, category_id: category.id, question_id: question.id)}
  
  before do
    controller.stub(:current_user).and_return(user)
    @question_types = [question_type]
    @valid_attributes = { name: "Test" }
    QuestionType.stub(:order).with('created_at desc').and_return(@question_types)
  end
  
  describe "index" do 
    def send_request
      get :index
    end
    
    it_should 'should_receive authorize_resource'
    it_should "call before_action find_question_types"

    before do 
      should_authorize(:index, QuestionType)
      QuestionType.stub(:new).and_return(question_type)
      QuestionType.stub(:find).and_return(question_type)
    end

    it "should_receive new" do 
      QuestionType.should_receive(:new).and_return(question)
      send_request
    end

    it "should assign instance variable" do
      send_request 
      expect(assigns[:question_type]).to eq(question_type)
    end

    it "should render_template index" do 
      send_request
      response.should render_template "index"
    end
  end

  describe "CREATE" do 
    def send_request
      post :create, question_type: {name: "test"}
    end
    
    it_should 'should_receive authorize_resource'

    before do 
      should_authorize(:create, QuestionType)
      QuestionType.stub(:new).with(@valid_attributes).and_return(question_type)
      controller.stub(:params_question_type).and_return(@valid_attributes)
    end

    describe "should_receive methods" do 
      it "should_receive new" do 
        QuestionType.should_receive(:new).with(@valid_attributes).and_return(question_type)
      end

      it "should_receive params_question_type" do 
        controller.should_receive(:params_question_type).and_return(@valid_attributes)
      end

      it "should_receive save" do 
        question_type.should_receive(:save).and_return(true)
      end

      after do 
        send_request
      end
    end
    
    it "should assigns instance variable" do 
      send_request
      expect(assigns[:question_type]).to eq(question_type)
    end
    
    context "question created" do 
      before do 
        question_type.stub(:save).and_return(true)
        send_request
      end

      it "should have a flash message" do 
        flash[:notice].should eq("#{question_type.name} has been created successfully")
      end

      it "should redirect_to index" do 
        response.should redirect_to question_types_path
      end
    end

    context "question not created" do 
      before do 
        question_type.stub(:save).and_return(false)
      end

      it "should not have a flash message" do
        send_request 
        flash[:notice].should_not eq("#{question_type.name} has been created successfully")
      end

      it "should not redirect_to index" do 
        send_request
        response.should_not redirect_to question_types_path
      end

      it "should render_template index" do 
        send_request
        response.should render_template "index"
      end

      it_should "call before_action find_question_types"

    end
  end

  describe "SHOW" do 
    def send_request
      xhr :get, :show, id: question_type.id
    end

    it_should 'should_receive authorize_resource'
    it_should 'call before_action load_resource for question type' 

    before do 
      should_authorize(:show, question_type)
      QuestionType.stub(:find).and_return(question_type)
    end

    context "html request" do 
      def send_request
        get :show, id: question_type.id
      end

      before do 
        request.env["HTTP_REFERER"] = question_types_path
      end

      it "should redirect_to request.referrer" do 
        send_request
        response.should redirect_to question_types_path
      end
    end

    context "xhr request" do 
      it "should render_template show" do 
        send_request
        response.should render_template "show"
      end
    end
  end

  describe "UPDATE" do 
    def send_request
      put :update, id: question_type.id
    end

    it_should 'should_receive authorize_resource'
    it_should "call before_action load_resource for question type" 

    before do 
      should_authorize(:update, question_type)
      QuestionType.stub(:find).and_return(question_type)
      controller.stub(:params_question_type).and_return(@valid_attributes)
      question_type.stub(:update_attributes).with(@valid_attributes).and_return(true)
    end

    it "should_receive params_question" do 
      controller.should_receive(:params_question_type).and_return(@valid_attributes)
      send_request
    end

    it "should_receive update_attributes" do 
      question_type.should_receive(:update_attributes).with(@valid_attributes).and_return(true)
      send_request
    end

    context "record updated" do 
      before do 
        question_type.stub(:update_attributes).and_return(true)
        send_request
      end

      it "should have flas notice" do 
        flash[:notice].should eq("#{question_type.name} has been updated successfully")
      end

      it "should redirect_to index" do 
        response.should redirect_to question_types_path
      end
    end

    context "record not created" do 
      before do 
        question_type.stub(:update_attributes).and_return(false)
      end

      it "should not have flash notice" do 
        send_request
        flash[:notice].should_not eq("#{question_type.name} has been updated successfully")
      end

      it "should not redirect_to index" do 
        send_request
        response.should_not redirect_to question_types_path
      end

      it "should render_template edit" do 
        send_request
        response.should render_template "index"
      end

      it_should 'call before_action find_question_types'

    end
  end

  describe "DESTROY" do 
    def send_request
      delete :destroy, id: question_type.id
    end

    it_should 'should_receive authorize_resource'
    it_should "call before_action load_resource for question type" 

    before do 
      should_authorize(:destroy, question_type)
      QuestionType.stub(:find).and_return(question_type)
    end

    it "should_receive destroy" do 
      question_type.should_receive(:destroy).and_return(true)
      send_request
    end

    it "should redirect_to index" do 
      send_request
      response.should redirect_to question_types_path
    end

    context "record destroyed" do 
      before do 
        question_type.stub(:destroy).and_return(true)
        send_request
      end

      it "should have a flash notice" do 
        flash[:notice].should eq("#{question_type.name} has been deleted successfully")
      end
    end

    context "record not destroyed" do 
      before do 
        question.stub(:destroy).and_return(false)
        send_request
      end

      it "should have a flash alert" do 
        flash[:alert].should eq("#{question_type.name} could not be deleted. please delete the associated questions first")
      end
    end
  end
  
  describe "params_question_type" do
    def send_request
      post :create, question_type: {name: "start", value: "1"}
    end

    before do 
      should_authorize(:create, QuestionType)
    end

    it 'should_receive with name only' do
      QuestionType.should_receive(:new).with({name: "start"}.with_indifferent_access).and_return(question_type)
      send_request
    end
  end


end
