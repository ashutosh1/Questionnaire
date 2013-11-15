require 'spec_helper'
include ControllerHelper

describe QuestionsController do

  shared_examples_for "call before_action load_resource for questions" do 

    it "Question should_receive find" do 
      Question.should_receive(:find).and_return(question)
      send_request
    end

    context "record found" do 
      it "should assign instance variable" do 
        send_request
        expect(assigns[:question]).to eq(question)
      end
    end

    context "record not found" do 
      before do 
        Question.stub(:find).and_return(nil)
      end

      it "should raise exception" do 
        expect{ send_request }.to raise_exception
      end
    end

  end
  
  shared_examples_for "call current_class_name" do
    describe "current_class_name" do 
      context "params[:type] not present" do 
        it "Question should_receive includes" do 
          Question.should_receive(:includes).with(:question_level, :user, :categories, :tags, :test_sets).and_return(@questions)
          send_request
        end
      end

      context "params[:type] present" do 
        it "should_receive includes" do 
          Subjective.should_receive(:includes).with(:question_level, :user, :categories, :tags, :test_sets).and_return(@questions)
          get :index, type: "Subjective"
        end        
      end
    end
  end

  let(:user) { mock_model(User, save: true, id: 1, email: "ashutosh.tiwari@vinsol.com") }
  let(:role) { mock_model(Role, save: true, id: 1, name: User::ROLES.first) }
  let(:roles_user) { mock_model(RolesUser, save: true, id: 1, role_id: role1.id, user_id: user.id) }
  let(:category1) {mock_model(Category, save: true, id: 1, name: 'category1')}
  let(:category2) {mock_model(Category, save: true, id: 2, name: 'category2')}
  let(:question_level) {mock_model(QuestionLevel, save: true, id: 2, name: 'beginner')}
  let(:question) { mock_model(Question, save: true, question: "What is sql?", question_level_id: question_level.id, user_id: user.id, type: 'Subjective', tags_field: "also", category_field: "#{category1.id}", "options_attributes"=>{"1384334256874"=>{"answer"=>"1", "option"=>"asdfsafa", "_destroy"=>"false"}}) }
  let(:categories_question1) {mock_model(CategoriesQuestion, save: true, category_id: category1.id, question_id: question.id)}
  let(:categories_question2) {mock_model(CategoriesQuestion, save: true, category_id: category2.id, question_id: question.id)}
  let(:tag) {mock_model(ActsAsTaggableOn::Tag, save: true, name: 'outdated')} 
  let(:tagging) {mock_model(ActsAsTaggableOn::Tagging)} 
  let(:test_set) {mock_model(TestSet)} 

  before do
    controller.stub(:current_user).and_return(user)
    @users = [user]
    @test_sets = [test_set]
    @questions = [question]
    @valid_attributes = { question: "How r u?", question_level_id: question_level.id, user_id: user.id, type: 'Subjective', tags_field: "also", category_field: "#{category2.id}", "options_attributes"=>{"1384334256874"=>{"answer"=>"1", "option"=>"asdfsafa", "_destroy"=>"false"}}}
    question.stub(:categories_questions).and_return([categories_question1])
    Category.stub(:where).with(["id NOT IN (?)", [question.id]]).and_return([category2])
    category2.stub(:categories_questions).and_return(categories_question2)
    category1.stub(:categories_questions).and_return(categories_question1)
    categories_question2.stub(:build).and_return(categories_question2)
    categories_question1.stub(:build).and_return(categories_question1)
    Category.stub(:all).and_return([category1, category2])
  end

  describe "autocomplete for tag" do 
    it "should define autocomplete method for tag name" do 
      QuestionsController.method_defined?(:autocomplete_tag_name).should be_true
    end
  end

  describe "autocomplete for category" do 
    it "should define autocomplete method for category name" do 
      QuestionsController.method_defined?(:autocomplete_category_name).should be_true
    end
  end

  
  describe "index" do 
    def send_request
      get :index
    end
    
    it_should 'should_receive authorize_resource'
    it_should "call current_class_name"

    before do 
      should_authorize(:index, Question)
      Question.stub(:includes).with(:question_level, :user, :categories, :tags, :test_sets).and_return(@questions)
    end

    it "should_receive includes" do 
      Question.should_receive(:includes).with(:question_level, :user, :categories, :tags, :test_sets).and_return(@questions)
      send_request
    end

    it "should assign instance variable" do
      send_request 
      expect(assigns[:questions]).to eq(@questions)
    end

    it "should render_template index" do 
      send_request
      response.should render_template "index"
    end

    context "params[:question_level_id] present" do 
      def send_request
        get :index, question_level_id: 1 
      end

      before do 
        @questions.stub(:where).with(question_level_id: "1").and_return(@questions)
      end

      it "should_receive where" do 
        @questions.should_receive(:where).with(question_level_id: "1").and_return(@questions)
        send_request
      end

      it "should assign instance variable" do
        send_request 
        expect(assigns[:questions]).to eq(@questions)
      end
    end

    context "params[:question_level_id] not present" do 
      it "should_receive where" do 
        @questions.should_not_receive(:where)
        send_request
      end
    end
  end

  describe "NEW" do 
    def send_request
      get :new
    end
    
    it_should 'should_receive authorize_resource'

    before do 
      should_authorize(:new, Question)
      user.stub(:questions).and_return(@questions)
      @questions.stub(:build).and_return(question)
    end
    
    describe "should_receive methods" do 
      it "should_receive current_user" do
        controller.should_receive(:current_user).and_return(user)
      end

      it "should_receive questions" do 
        user.should_receive(:questions).and_return(@questions)
      end

      it "should_receive build" do 
        @questions.should_receive(:build).and_return(question)
      end

      after do 
        send_request
      end
    end

    it "should assigns instance variable" do 
      send_request
      expect(assigns[:question]).to eq(question)
    end

    it "should render_template new" do 
      send_request
      response.should render_template "new"
    end
  end

  describe "CREATE" do 
    def send_request
      post :create, question: {question: "How was the test?", question_level_id: question_level.id, user_id: user.id, type: 'Subjective', tags_field: "also", category_field: "#{category1.id}", "options_attributes"=>{"1384334256874"=>{"answer"=>"1", "option"=>"asdfsafa", "_destroy"=>"false"}}}
    end
    
    it_should 'should_receive authorize_resource'

    before do 
      should_authorize(:create, Question)
      controller.stub(:params_question).and_return(@valid_attributes)
      user.stub(:questions).and_return(@questions)
      @questions.stub(:build).and_return(question)
    end

    describe "should_receive methods" do 
      it "should_receive current_user" do 
        controller.should_receive(:current_user).and_return(user)
      end

      it "should_receive questions" do 
        user.should_receive(:questions).and_return(@questions)
      end

      it "should_receive build" do 
        @questions.should_receive(:build).and_return(question)
      end

      it "should_receive params_question" do 
        controller.should_receive(:params_question).and_return(@valid_attributes)
      end

      it "should_receive save" do 
        question.should_receive(:save).and_return(true)
      end

      after do 
        send_request
      end
    end
    
    it "should assigns instance variable" do 
      send_request
      expect(assigns[:question]).to eq(question)
    end
    
    context "question created" do 
      before do 
        question.stub(:save).and_return(true)
        send_request
      end

      it "should have a flash message" do 
        flash[:notice].should eq("Question has been created successfully")
      end

      it "should redirect_to index" do 
        response.should redirect_to questions_path
      end
    end

    context "question not created" do 
      before do 
        question.stub(:save).and_return(false)
      end

      it "should not have a flash message" do
        send_request 
        flash[:notice].should_not eq("Question has been created successfully")
      end

      it "should not redirect_to index" do 
        send_request
        response.should_not redirect_to questions_path
      end

      it "should render_template new" do 
        send_request
        response.should render_template "new"
      end
    end
  end

  describe "SHOW" do 
    def send_request
      get :show, id: question.id
    end

    it_should 'should_receive authorize_resource'
    it_should "call before_action load_resource for questions"

    before do 
      should_authorize(:show, question)
      Question.stub(:find).and_return(question)
      Question.stub(:where).with(id: question.id.to_s).and_return(@questions)
      @questions.stub(:includes).with(:question_level, :user, :categories).and_return(@questions)
    end

    it "should render_template show" do 
      send_request
      response.should render_template "show"
    end
  end

  describe "EDIT" do 
    def send_request
      get :edit, id: question.id
    end

    it_should 'should_receive authorize_resource'
    it_should "call before_action load_resource for questions"
    
    before do 
      should_authorize(:edit, question)
      Question.stub(:find).and_return(question)
    end

    it "should render_template edit" do
      send_request
      response.should render_template "edit"
    end    
  end

  describe "UPDATE" do 
    def send_request
      put :update, id: question.id
    end

    it_should 'should_receive authorize_resource'
    it_should "call before_action load_resource for questions"
    
    before do 
      should_authorize(:update, question)
      Question.stub(:find).and_return(question)
      controller.stub(:params_question).and_return(@valid_attributes)
      question.stub(:update_attributes).with(@valid_attributes).and_return(true)
    end

    it "should_receive params_question" do 
      controller.should_receive(:params_question).and_return(@valid_attributes)
      send_request
    end

    it "should_receive update_attributes" do 
      question.should_receive(:update_attributes).with(@valid_attributes).and_return(true)
      send_request
    end

    context "record updated" do 
      before do 
        question.stub(:update_attributes).and_return(true)
        send_request
      end

      it "should have flas notice" do 
        flash[:notice].should eq("Question has been updated successfully")
      end

      it "should redirect_to index" do 
        response.should redirect_to questions_path
      end
    end

    context "record not created" do 
      before do 
        question.stub(:update_attributes).and_return(false)
      end

      it "should not have flash notice" do 
        send_request
        flash[:notice].should_not eq("Question has been updated successfully")
      end

      it "should not redirect_to index" do 
        send_request
        response.should_not redirect_to questions_path
      end

      it "should render_template edit " do 
        send_request
        response.should render_template "edit"
      end
    end
  end

  describe "DESTROY" do 
    def send_request
      delete :destroy, id: question.id
    end

    it_should 'should_receive authorize_resource'
    it_should "call before_action load_resource for questions"
    
    before do 
      should_authorize(:destroy, question)
      Question.stub(:find).and_return(question)
      request.env["HTTP_REFERER"] = questions_path
    end

    it "should_receive destroy" do 
      question.should_receive(:destroy).and_return(true)
      send_request
    end

    it "should redirect_to index" do 
      send_request
      response.should redirect_to questions_path
    end

    context "record destroyed" do 
      before do 
        question.stub(:destroy).and_return(true)
        send_request
      end

      it "should not have a flash alert" do 
        flash[:alert].should_not eq("Question could not be deleted. please delete the associated questions first")
      end

      it "should have a flash notice" do 
        flash[:notice].should eq("Question has been deleted successfully")
      end
    end

    context "record not destroyed" do 
      before do 
        question.stub(:destroy).and_return(false)
        send_request
      end

      it "should have a flash alert" do 
        flash[:alert].should eq("Question could not be deleted. please delete the associated questions first")
      end

      it "should not have a flash notice" do 
        flash[:notice].should_not eq("Question has been deleted successfully")
      end
    end
  end
  
  describe "params_question" do
    def send_request
      post :create, question: {question: "What is it?", question_level_id: question_level.id, user_id: user.id, type: 'Subjective', tags_field: "also", category_field: "#{category1.id}", "options_attributes"=>{"1384334256874"=>{"answer"=>"1", "option"=>"asdfsafa", "_destroy"=>"false"}}}
    end

    before do 
      should_authorize(:create, Question)
      user.stub(:questions).and_return(question)
    end

    it 'should_receive with data without name' do
      question.should_receive(:build).with({"question"=>"What is it?", "question_level_id"=>"2", "type"=>"Subjective", "user_id"=>"1", "tags_field"=>"also", "category_field"=>"1", "options_attributes"=>{"1384334256874"=>{"option"=>"asdfsafa", "answer"=>"1", "_destroy"=>"false"}}}.with_indifferent_access).and_return(question)
      send_request
    end
  end

  describe "#publish" do 
    def send_request
      put :publish, id: question.id 
    end

    it_should 'should_receive authorize_resource'
    it_should "call before_action load_resource for questions"
    
    before do 
      should_authorize(:publish, question)
      Question.stub(:find).and_return(question)
      question.stub(:publish!).and_return(true)
      request.env["HTTP_REFERER"] = questions_path
    end
    
    it "should_receive publish!" do
      question.should_receive(:publish!).and_return(true)
      send_request
    end

    it "should have a flash notice" do 
      send_request
      flash[:notice].should eq("Question successfully published")
    end

    it "should redirect_to back" do 
      send_request
      response.should redirect_to questions_path
    end
  end

  describe "#unpublish" do 
    def send_request
      put :unpublish, id: question.id 
    end

    it_should 'should_receive authorize_resource'
    it_should "call before_action load_resource for questions"
    
    before do 
      should_authorize(:unpublish, question)
      Question.stub(:find).and_return(question)
      question.stub(:unpublish!).and_return(true)
      request.env["HTTP_REFERER"] = questions_path
      question.stub(:test_sets).and_return(@test_sets)
      test_set.stub(:name).and_return("test")
    end
    
    it "should_receive publish!" do
      question.should_receive(:unpublish!).and_return(true)
      send_request
    end
    
    context "unpublished" do 
      it "should have a flash notice" do 
        send_request
        flash[:notice].should eq("Question successfully unpublished")
      end

      it "should not have a flash alert" do 
        send_request
        flash[:alert].should_not eq("Question is associated with test sets (#{question.test_sets.collect(&:name).join(', ')}), so it can not be unpublished.")
      end
    end

    context "not unpublished" do 
      before do
        question.stub(:unpublish!).and_return(false)
      end

      it "should have a flash alert" do 
        send_request
        flash[:alert].should eq("Question is associated with test sets (#{question.test_sets.collect(&:name).join(', ')}), so it can not be unpublished.")
      end

      it "should not have a flash notice" do 
        send_request
        flash[:notice].should_not eq("Question successfully unpublished")
      end
    end

    it "should redirect_to back" do 
      send_request
      response.should redirect_to questions_path
    end
  end

end
