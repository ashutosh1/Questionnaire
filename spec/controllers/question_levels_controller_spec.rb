require 'spec_helper'
include ControllerHelper

describe QuestionLevelsController do

  shared_examples_for "call before_action find_question_levels" do 
    it "should_receive order" do 
      QuestionLevel.should_receive(:order).with('created_at desc').and_return(@question_levels)
      send_request
    end
  
    it "should assigns instance variable" do 
      send_request
      expect(assigns[:question_levels]).to eq(@question_levels)
    end
  end

  shared_examples_for "call before_action load_resource for question type" do 

    it "QuestionLevel should_receive find" do 
      QuestionLevel.should_receive(:find).and_return(question_level)
      send_request
    end

    context "record found" do 
      it "should assign instance variable" do 
        send_request
        expect(assigns[:question_level]).to eq(question_level)
      end
    end

    context "record not found" do 
      before do 
        QuestionLevel.stub(:find).and_return(nil)
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
    @question_levels = [question_level]
    @valid_attributes = { name: "Test" }
    QuestionLevel.stub(:order).with('created_at desc').and_return(@question_levels)
  end
  
  describe "index" do 
    def send_request
      get :index
    end
    
    it_should 'should_receive authorize_resource'
    it_should "call before_action find_question_levels"

    before do 
      should_authorize(:index, QuestionLevel)
      QuestionLevel.stub(:new).and_return(question_level)
      QuestionLevel.stub(:find).and_return(question_level)
    end

    it "should_receive new" do 
      QuestionLevel.should_receive(:new).and_return(question)
      send_request
    end

    it "should assign instance variable" do
      send_request 
      expect(assigns[:question_level]).to eq(question_level)
    end

    it "should render_template index" do 
      send_request
      response.should render_template "index"
    end
  end

  describe "CREATE" do 
    def send_request
      post :create, question_level: {name: "test"}
    end
    
    it_should 'should_receive authorize_resource'

    before do 
      should_authorize(:create, QuestionLevel)
      QuestionLevel.stub(:new).with(@valid_attributes).and_return(question_level)
      controller.stub(:params_question_level).and_return(@valid_attributes)
    end

    describe "should_receive methods" do 
      it "should_receive new" do 
        QuestionLevel.should_receive(:new).with(@valid_attributes).and_return(question_level)
      end

      it "should_receive params_question_level" do 
        controller.should_receive(:params_question_level).and_return(@valid_attributes)
      end

      it "should_receive save" do 
        question_level.should_receive(:save).and_return(true)
      end

      after do 
        send_request
      end
    end
    
    it "should assigns instance variable" do 
      send_request
      expect(assigns[:question_level]).to eq(question_level)
    end
    
    context "question created" do 
      before do 
        question_level.stub(:save).and_return(true)
        send_request
      end

      it "should have a flash message" do 
        flash[:notice].should eq("#{question_level.name} has been created successfully")
      end

      it "should redirect_to index" do 
        response.should redirect_to question_levels_path
      end
    end

    context "question not created" do 
      before do 
        question_level.stub(:save).and_return(false)
      end

      it "should not have a flash message" do
        send_request 
        flash[:notice].should_not eq("#{question_level.name} has been created successfully")
      end

      it "should not redirect_to index" do 
        send_request
        response.should_not redirect_to question_levels_path
      end

      it "should render_template index" do 
        send_request
        response.should render_template "index"
      end

      it_should "call before_action find_question_levels"

    end
  end

  describe "SHOW" do 
    def send_request
      xhr :get, :show, id: question_level.id
    end

    it_should 'should_receive authorize_resource'
    it_should 'call before_action load_resource for question type' 

    before do 
      should_authorize(:show, question_level)
      QuestionLevel.stub(:find).and_return(question_level)
    end

    context "html request" do 
      def send_request
        get :show, id: question_level.id
      end

      before do 
        request.env["HTTP_REFERER"] = question_levels_path
      end

      it "should redirect_to request.referrer" do 
        send_request
        response.should redirect_to question_levels_path
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
      put :update, id: question_level.id
    end

    it_should 'should_receive authorize_resource'
    it_should "call before_action load_resource for question type" 

    before do 
      should_authorize(:update, question_level)
      QuestionLevel.stub(:find).and_return(question_level)
      controller.stub(:params_question_level).and_return(@valid_attributes)
      question_level.stub(:update_attributes).with(@valid_attributes).and_return(true)
    end

    it "should_receive params_question" do 
      controller.should_receive(:params_question_level).and_return(@valid_attributes)
      send_request
    end

    it "should_receive update_attributes" do 
      question_level.should_receive(:update_attributes).with(@valid_attributes).and_return(true)
      send_request
    end

    context "record updated" do 
      before do 
        question_level.stub(:update_attributes).and_return(true)
        send_request
      end

      it "should have flas notice" do 
        flash[:notice].should eq("#{question_level.name} has been updated successfully")
      end

      it "should redirect_to index" do 
        response.should redirect_to question_levels_path
      end
    end

    context "record not created" do 
      before do 
        question_level.stub(:update_attributes).and_return(false)
      end

      it "should not have flash notice" do 
        send_request
        flash[:notice].should_not eq("#{question_level.name} has been updated successfully")
      end

      it "should not redirect_to index" do 
        send_request
        response.should_not redirect_to question_levels_path
      end

      it "should render_template edit" do 
        send_request
        response.should render_template "index"
      end

      it_should 'call before_action find_question_levels'

    end
  end

  describe "DESTROY" do 
    def send_request
      delete :destroy, id: question_level.id
    end

    it_should 'should_receive authorize_resource'
    it_should "call before_action load_resource for question type" 

    before do 
      should_authorize(:destroy, question_level)
      QuestionLevel.stub(:find).and_return(question_level)
    end

    it "should_receive destroy" do 
      question_level.should_receive(:destroy).and_return(true)
      send_request
    end

    it "should redirect_to index" do 
      send_request
      response.should redirect_to question_levels_path
    end

    context "record destroyed" do 
      before do 
        question_level.stub(:destroy).and_return(true)
        send_request
      end

      it "should have a flash notice" do 
        flash[:notice].should eq("#{question_level.name} has been deleted successfully")
      end
    end

    context "record not destroyed" do 
      before do 
        question.stub(:destroy).and_return(false)
        send_request
      end

      it "should have a flash alert" do 
        flash[:alert].should eq("#{question_level.name} could not be deleted. please delete the associated questions first")
      end
    end
  end
  
  describe "params_question_level" do
    def send_request
      post :create, question_level: {name: "start", value: "1"}
    end

    before do 
      should_authorize(:create, QuestionLevel)
    end

    it 'should_receive with name only' do
      QuestionLevel.should_receive(:new).with({name: "start"}.with_indifferent_access).and_return(question_level)
      send_request
    end
  end


end
