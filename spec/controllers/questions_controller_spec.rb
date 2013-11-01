require 'spec_helper'
include ControllerHelper

describe QuestionsController do

  shared_examples_for 'call build_categories_questions' do 
    describe "should_receive methods" do 
      it "should_receive categories_questions" do 
        question.should_receive(:categories_questions).twice.and_return([categories_question1])
      end

      it "Category should_receive where" do 
        Category.should_receive(:where).with(["id NOT IN (?)", [question.id]]).and_return([category2])
      end

      it "should_receive categories_questions" do 
        category2.should_receive(:categories_questions).and_return(categories_question2)
      end

      it "should_receive build" do 
        categories_question2.should_receive(:build).and_return(categories_question2)
      end

      after do 
        send_request
      end
    end

    it "should assign instance variable categories_questions" do 
      send_request
      expect(assigns[:categories_questions]).to eq([categories_question1, categories_question2])
    end

    context "question has no category" do 
      before do 
        question.stub(:categories_questions).and_return([])
        Category.stub(:where).with(["id NOT IN (?)", []]).and_return([])
        category1.stub(:categories_questions).and_return(categories_question1)
        category2.stub(:categories_questions).and_return(categories_question2)
      end
      describe "should_receive methods" do 

        it "Category should_receive all" do 
          Category.should_receive(:all).and_return([category1, category2])
        end

        it "category1 should_receive categories_questions" do 
          category1.should_receive(:categories_questions).and_return(categories_question1)
        end

        it "categories_question1 should_receive build" do 
          categories_question1.should_receive(:build).and_return(categories_question1)
        end

        it "category2 should_receive categories_questions" do 
          category2.should_receive(:categories_questions).and_return(categories_question2)
        end

        it "categories_question2 should_receive build" do 
          categories_question2.should_receive(:build).and_return(categories_question2)
        end

        after do 
          send_request
        end
      end

      it "should assign instance variable" do 
        send_request
        expect(assigns[:categories_questions]).to eq([categories_question1, categories_question2])
      end
    end

    context "question has category" do 
      it "Category should_not_receive all" do 
        Category.should_not_receive(:all)
      end

      it "category1 should_not_receive categories_questions" do 
        category1.should_not_receive(:categories_questions)
      end

      it "categories_question1 should_not_receive build" do 
        categories_question1.should_not_receive(:build)
      end

      after do 
        send_request
      end
    end
  end

  shared_examples_for "call before_action find_user" do 
    describe "should_receive methods" do 
      it "should_receive where" do 
        Question.should_receive(:where).with(id: question.id.to_s).and_return(@questions)
      end

      it "should_receive includes" do 
        @questions.should_receive(:includes).with(:question_type, :question_level, :user, :categories).and_return(@questions)
      end

      after do 
        send_request
      end
    end

    it "should assigns instance variable" do 
      send_request
      expect(assigns[:question]).to eq(question)
    end

    context "question not found" do 
      before do 
        @questions.should_receive(:includes).with(:question_type, :question_level, :user, :categories).and_return([])
        request.env["HTTP_REFERER"] = questions_path
        send_request
      end

      it "should have flash alert" do 
        flash[:alert].should eq("No question type found for specified id")
      end

      it "should redirect_to back" do 
        response.should redirect_to questions_path
      end
    end
  end

  let(:user) { mock_model(User, save: true, id: 1, email: "ashutosh.tiwari@vinsol.com") }
  let(:role) { mock_model(Role, save: true, id: 1, name: User::ROLES.first) }
  let(:roles_user) { mock_model(RolesUser, save: true, id: 1, role_id: role1.id, user_id: user.id) }
  let(:category1) {mock_model(Category, save: true, id: 1, name: 'category1')}
  let(:category2) {mock_model(Category, save: true, id: 2, name: 'category2')}
  let(:question_type) {mock_model(QuestionType, save: true, id: 1, name: 'mcq')}
  let(:question_level) {mock_model(Category, save: true, id: 2, name: 'beginner')}
  let(:question) { mock_model(Question, save: true, id: 1, question: "what is sql?", question_type_id: question_type.id, question_level_id: question_level.id, user_id: user.id) }
  let(:categories_question1) {mock_model(CategoriesQuestion, save: true, category_id: category1.id, question_id: question.id)}
  let(:categories_question2) {mock_model(CategoriesQuestion, save: true, category_id: category2.id, question_id: question.id)}

  before do
    controller.stub(:current_user).and_return(user)
    @users = [user]
    @questions = [question]
    @valid_attributes = { :question => "define test?", question_level_id: question_level.id, question_type_id: question_type.id }
    question.stub(:categories_questions).and_return([categories_question1])
    Category.stub(:where).with(["id NOT IN (?)", [question.id]]).and_return([category2])
    category2.stub(:categories_questions).and_return(categories_question2)
    category1.stub(:categories_questions).and_return(categories_question1)
    categories_question2.stub(:build).and_return(categories_question2)
    categories_question1.stub(:build).and_return(categories_question1)
    Category.stub(:all).and_return([category1, category2])
  end
  
  describe "index" do 
    def send_request
      get :index
    end
    
    it_should 'should_receive authorize_resource'

    before do 
      should_authorize(:index, Question)
      Question.stub(:includes).with(:question_type, :question_level, :user, :categories).and_return(@questions)
    end

    it "should_receive includes" do 
      Question.should_receive(:includes).with(:question_type, :question_level, :user, :categories).and_return(@questions)
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

    it_should 'call build_categories_questions'

  end

  describe "CREATE" do 
    def send_request
      post :create, question: {question: "Test question?", question_type_id: question_type.id, question_level_id: question_level.id}
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

      it_should 'call build_categories_questions'

    end
  end

  describe "SHOW" do 
    def send_request
      get :show, id: question.id
    end

    it_should 'should_receive authorize_resource'

    before do 
      should_authorize(:show, question)
      Question.stub(:where).with(id: question.id.to_s).and_return(@questions)
      @questions.stub(:includes).with(:question_type, :question_level, :user, :categories).and_return(@questions)
    end

    it "should render_template show" do 
      send_request
      response.should render_template "show"
    end

    it_should "call before_action find_user" 
  end

  describe "EDIT" do 
    def send_request
      get :edit, id: question.id
    end

    it_should 'should_receive authorize_resource'
    it_should 'call build_categories_questions'
    it_should "call before_action find_user" 

    before do 
      should_authorize(:edit, question)
      Question.stub(:where).with(id: question.id.to_s).and_return(@questions)
      @questions.stub(:includes).with(:question_type, :question_level, :user, :categories).and_return(@questions)
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
    it_should "call before_action find_user" 

    before do 
      should_authorize(:update, question)
      Question.stub(:where).with(id: question.id.to_s).and_return(@questions)
      @questions.stub(:includes).with(:question_type, :question_level, :user, :categories).and_return(@questions)
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

      it_should 'call build_categories_questions'

    end
  end

  describe "DESTROY" do 
    def send_request
      delete :destroy, id: question.id
    end

    it_should 'should_receive authorize_resource'
    it_should "call before_action find_user" 

    before do 
      should_authorize(:destroy, question)
      Question.stub(:where).with(id: question.id.to_s).and_return(@questions)
      @questions.stub(:includes).with(:question_type, :question_level, :user, :categories).and_return(@questions)
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
      post :create, question: {"name"=>"test", "question"=>"who are u?", "question_level_id"=>"2", "question_type_id"=>"1", "user_id"=>"1", "categories_questions_attributes"=>{"0"=>{"category_id"=>"4", "id"=>"6", "_destroy"=>"0"}}, "options_attributes"=>{"1383260832744"=>{"option"=>"zscvazdvs", "answer"=>"0", "_destroy"=>"false"}}}
    end

    before do 
      should_authorize(:create, Question)
      user.stub(:questions).and_return(question)
    end

    it 'should_receive with data without name' do
      question.should_receive(:build).with({"question"=>"who are u?", "question_level_id"=>"2", "question_type_id"=>"1", "user_id"=>"1", "categories_questions_attributes"=>{"0"=>{"category_id"=>"4", "id"=>"6", "_destroy"=>"0"}}, "options_attributes"=>{"1383260832744"=>{"option"=>"zscvazdvs", "answer"=>"0", "_destroy"=>"false"}}}.with_indifferent_access).and_return(question)
      send_request
    end
  end


end
