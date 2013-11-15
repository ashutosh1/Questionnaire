require 'spec_helper'
include ControllerHelper

describe TestSetsController do

  shared_examples_for "call before_action load_resource for test sets" do 

    it "Question should_receive find" do 
      TestSet.should_receive(:find_by_permalink!).and_return(test_set)
      send_request
    end

    context "record found" do 
      it "should assign instance variable" do 
        send_request
        expect(assigns[:test_set]).to eq(test_set)
      end
    end

    context "record not found" do 
      before do 
        TestSet.stub(:find_by_permalink!).and_return(nil)
      end

      it "should raise exception" do 
        expect{ send_request }.to raise_exception
      end
    end

  end

  shared_examples_for "call before_action find_questions" do 
    it "should_receive where" do 
      Question.should_receive(:where).with(id: [question.id.to_s]).and_return(@questions)
      send_request
    end
    
    it "should assigns instance variable" do 
      send_request
      expect(assigns[:questions]).to eq(@questions)
    end

    context "record found" do 
      it "should not have a flash alert" do 
        send_request
        flash[:alert].should_not eq("There are no questions for this test set")
      end
    end

    context "record not found" do 
      before do 
        Question.stub(:where).and_return(nil)
        request.env["HTTP_REFERER"] = test_sets_path
      end

      it "should redirect_to back" do 
        send_request
        response.should redirect_to test_sets_path
      end

      it "should have a flash alert" do 
        send_request
        flash[:alert].should eq("There are no questions for this test set")
      end
    end

  end

  shared_examples_for 'call before_action assign_variables for test sets' do |params_attr|
    describe "assign instance variables" do 
      before do 
        send_request
      end

      it "should assign question_types" do 
        expect(assigns[:question_types]).to eq(params_attr["query"].keys)
      end
      it "should assign query" do 
        expect(assigns[:query]).to eq(params_attr["query"])
      end
      it "should assign categories" do 
        expect(assigns[:categories]).to eq(params_attr["category"])
      end
      it "should assign tags" do 
        expect(assigns[:tags]).to eq(params_attr["tags"])
      end
    end
  end

  shared_examples_for "call before_action filter_and_get_num_of_questions" do 
    it "should_receive get_questions" do 
      TestSet.should_receive(:get_questions).with(@search_query["query"].keys, @search_query["query"], @search_query["category"], @search_query["tags"]).and_return(@questions)
      send_request
    end

    it "should assign instance variable questions" do 
      send_request
      expect(assigns[:questions]).to eq(question)
    end

    it "should assign instance variable errors" do 
      send_request
      expect(assigns[:errors]).to eq(nil)
    end
  end
  
  let(:user) { mock_model(User, save: true, id: 1, email: "ashutosh.tiwari@vinsol.com") }
  let(:role) { mock_model(Role, save: true, id: 1, name: User::ROLES.first) }
  let(:roles_user) { mock_model(RolesUser, save: true, id: 1, role_id: role1.id, user_id: user.id) }
  let(:category1) {mock_model(Category, save: true, id: 1, name: 'category1')}
  let(:question_level) {mock_model(QuestionLevel, save: true, id: 2, name: 'beginner')}
  let(:question) { mock_model(Question, save: true, question: "What is sql?", question_level_id: question_level.id, user_id: user.id, type: 'Subjective', tags_field: "also", category_field: "#{category1.id}", "options_attributes"=>{"1384334256874"=>{"answer"=>"1", "option"=>"asdfsafa", "_destroy"=>"false"}}) }
  let(:test_set) {mock_model(TestSet, save: true, name: "test", instruction: "fill all", permalink: "test")} 

  before do
    controller.stub(:current_user).and_return(user)
    @test_sets = [test_set]
    @questions = [question]
    @valid_attributes = {name: "demo", instruction: "don't copy" }
  end

  describe "index" do 
    def send_request
      get :index, page: 1
    end
    
    it_should 'should_receive authorize_resource'

    before do 
      should_authorize(:index, TestSet)
      TestSet.stub(:order).with("created_at desc").and_return(@test_sets)
      @test_sets.stub(:paginate).with(:page => "1", :per_page => 100).and_return(@test_sets)
    end

    it "should_receive order" do 
      TestSet.stub(:order).with("created_at desc").and_return(@test_sets)
      send_request
    end

    it "should_receive paginate" do 
      @test_sets.stub(:paginate).with(:page => "1", :per_page => 100).and_return(@test_sets)
      send_request
    end

    it "should assign instance variable" do
      send_request 
      expect(assigns[:test_sets]).to eq(@test_sets)
    end

    it "should render_template index" do 
      send_request
      response.should render_template "index"
    end
  end

  describe "CREATE" do 
    def send_request
      post :create, test_set: {name: "set", instruction: "do not copy"}, question_id: "#{question.id}"
    end
    
    it_should 'should_receive authorize_resource'
    it_should "call before_action find_questions"

    before do 
      should_authorize(:create, TestSet)
      controller.stub(:params_test_set).and_return(@valid_attributes)
      TestSet.stub(:new).with(@valid_attributes).and_return(test_set)
      test_set.stub(:questions=).and_return(@questions)
      test_set.stub(:save).and_return(true)
      Question.stub(:where).with(id: [question.id.to_s]).and_return(@questions)
    end

    describe "should_receive methods" do 
      it "should_receive params_question" do 
        controller.stub(:params_test_set).and_return(@valid_attributes)
      end

      it "should_receive new" do 
        TestSet.stub(:new).with(@valid_attributes).and_return(test_set)
      end


      it "should_receive question" do 
        test_set.stub(:questions=).and_return(@questions)
      end

      it "should_receive save" do 
        test_set.stub(:save).and_return(true)
      end

      after do 
        send_request
      end
    end
    
    it "should assigns instance variable" do 
      send_request
      expect(assigns[:test_set]).to eq(test_set)
    end
    
    context "test_set created" do 
      before do 
        test_set.stub(:save).and_return(true)
      end
      context "num_of_sets not present" do 

        it "should have a flash message" do 
          send_request
          flash[:notice].should eq("Test Set has been created successfully")
        end

        it "should redirect_to index" do 
          send_request
          response.should redirect_to test_sets_path
        end
      end

      context "num_of_sets present" do 
        def send_request
          post :create, test_set: {name: "set", instruction: "do not copy"}, question_id: "#{question.id}", num_of_sets: 2
        end

        before do 
          test_set.stub(:file_name).and_return("file_name")
          File.open("public/reports/#{test_set.file_name}.zip", "w"){|f|}
          @file = File.new("public/reports/#{test_set.file_name}.zip")
          test_set.stub(:generate_different_sets)
          File.stub(:new).and_return(@file)
          @file.stub(:read).and_return(@file)
          # controller.stub(:send_data).with(@file, :type=>"application/zip", :disposition=>"attachment", :filename => "file_name.zip").and_return(true)
        end
        
        it_should 'use generate_and_send_sets module'

        it "should not render_template" do 
          send_request
          response.should render_template nil
        end

      end
    end

    context "test_set not created" do 
      before do 
        test_set.stub(:save).and_return(false)
      end

      it "should not have a flash message" do
        send_request 
        flash[:notice].should_not eq("TestSet has been created successfully")
      end

      it "should not redirect_to index" do 
        send_request
        response.should_not redirect_to test_sets_path
      end

      it "should render_template search_conditions" do 
        send_request
        response.should render_template "search_questions"
      end
    end
  end

  describe "SHOW" do 
    def send_request
      get :show, id: test_set.permalink
    end

    it_should 'should_receive authorize_resource'
    it_should "call before_action load_resource for test sets"


    before do 
      should_authorize(:show, test_set)
      TestSet.stub(:find_by_permalink!).and_return(test_set)
    end

    it "should render_template show" do 
      send_request
      response.should render_template "show"
    end
  end

  describe "#search_questions" do 
    def send_request
      get :search_questions, @search_query
    end

    it_should 'should_receive authorize_resource'
    it_should 'call before_action assign_variables for test sets', {"category"=>"geography,", "tags"=>"also,", "query"=>{"Subjective"=>{"number_of_questions"=>"2", "random"=>"true", "levels"=>{"1"=>{"number_of_questions"=>""}, "2"=>{"number_of_questions"=>""}, "3"=>{"number_of_questions"=>""}}}, "Mcq"=>{"number_of_questions"=>"2", "levels"=>{"1"=>{"number_of_questions"=>"1"}, "2"=>{"number_of_questions"=>"1"}, "3"=>{"number_of_questions"=>""}}}, "Mcqma"=>{"number_of_questions"=>"1", "levels"=>{"1"=>{"number_of_questions"=>""}, "2"=>{"number_of_questions"=>""}, "3"=>{"number_of_questions"=>"1"}}}}}
    it_should "call before_action filter_and_get_num_of_questions"

    before do 
      should_authorize(:search_questions, TestSet)
      TestSet.stub(:new).and_return(test_set)
      @search_query = {"category"=>"geography,", "tags"=>"also,", "query"=>{"Subjective"=>{"number_of_questions"=>"2", "random"=>"true", "levels"=>{"1"=>{"number_of_questions"=>""}, "2"=>{"number_of_questions"=>""}, "3"=>{"number_of_questions"=>""}}}, "Mcq"=>{"number_of_questions"=>"2", "levels"=>{"1"=>{"number_of_questions"=>"1"}, "2"=>{"number_of_questions"=>"1"}, "3"=>{"number_of_questions"=>""}}}, "Mcqma"=>{"number_of_questions"=>"1", "levels"=>{"1"=>{"number_of_questions"=>""}, "2"=>{"number_of_questions"=>""}, "3"=>{"number_of_questions"=>"1"}}}}}
      TestSet.stub(:get_questions).with(@search_query["query"].keys, @search_query["query"], @search_query["category"], @search_query["tags"]).and_return(@questions)
    end

    it "should_receive new" do 
      TestSet.should_receive(:new).and_return(test_set)
      send_request
    end

    it "should assign instance variable" do 
      send_request
      expect(assigns[:test_set]).to eq(test_set)
    end

    it "should render_template search_questions" do 
      send_request
      response.should render_template "search_questions"
    end
  end

  describe "NEW" do 
    def send_request
      get :new
    end
    
    it_should 'should_receive authorize_resource'

    before do 
      should_authorize(:new, TestSet)
    end

    it "should render_template new" do 
      send_request
      response.should render_template "new"
    end
  end
  
  describe "#download_sets" do 
    def send_request
      get :download_sets, id: test_set.id, num_of_sets: 2
    end

    it_should 'should_receive authorize_resource'
    it_should "call before_action load_resource for test sets"
    it_should 'use generate_and_send_sets module'

    before do 
      should_authorize(:download_sets, test_set)
      TestSet.stub(:find_by_permalink!).and_return(test_set)
      test_set.stub(:file_name).and_return("file_name")
      File.open("public/reports/#{test_set.file_name}.zip", "w"){|f|}
      @file = File.new("public/reports/#{test_set.file_name}.zip")
      test_set.stub(:generate_different_sets)
      File.stub(:new).and_return(@file)
      @file.stub(:read).and_return(@file)
      # controller.stub(:send_data).with(@file, :type=>"application/zip" , :filename => "file_name.zip").and_return(true)
    end

    it "should not render_template" do 
      send_request
      response.should render_template nil
    end
  end

  describe "params_test_set" do
    def send_request
      post :create, test_set: {name: "set", instruction: "do not copy"}, question_id: "#{question.id}"
    end

    before do 
      should_authorize(:create, TestSet)
      test_set.stub(:questions=).and_return(@questions)
      test_set.stub(:save).and_return(true)
    end

    it 'should_receive with name only' do
      TestSet.should_receive(:new).with({name: "set", instruction: "do not copy"}.with_indifferent_access).and_return(test_set)
      send_request
    end
  end


end