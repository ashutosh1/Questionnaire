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

  let(:user) { mock_model(User, save: true, id: 1, email: "ashutosh.tiwari@vinsol.com") }
  let(:category1) {mock_model(Category, save: true, id: 1, name: 'category1')}
  let(:question_level) {mock_model(QuestionLevel, save: true, id: 2, name: 'beginner')}
  let(:question) { mock_model(Question, save: true, question: "What is sql?", question_level_id: question_level.id, user_id: user.id, type: 'Subjective', tags_field: "also", category_field: "#{category1.id}", "options_attributes"=>{"1384334256874"=>{"answer"=>"1", "option"=>"asdfsafa", "_destroy"=>"false"}}) }
  let(:categories_question1) {mock_model(CategoriesQuestion, save: true, category_id: category1.id, question_id: question.id)}
  let(:tag) {mock_model(ActsAsTaggableOn::Tag, save: true, name: 'outdated')} 
  let(:tagging) {mock_model(ActsAsTaggableOn::Tagging)} 

  before do
    controller.stub(:current_user).and_return(user)
    @questions = [question]
    @tags = [tag]
  end


  describe "INDEX" do 
    def send_request
      get :index
    end
    
    it_should 'skip_authorize_resource for HomeController'

    before do 
      Question.stub(:tag_counts_on).with(:tags).and_return(@tags)
    end

    it "should render template index" do 
      send_request
      response.should render_template 'index'
    end

    it "should assigns instance variable" do 
      send_request
      expect(assigns[:tags]).to eq(@tags)
    end

    it "should receive tag_counts_on" do 
      Question.stub(:tag_counts_on).with(:tags).and_return(@tags)
      send_request
    end
  end

  describe "#show_tag" do 
    def send_request
      xhr :get, :show_tag, tag: tag.name
    end

    it_should 'skip_authorize_resource for HomeController'

    before do 
      Question.stub(:tagged_with).with(tag.name, on: :tags).and_return(@questions)
      @questions.stub(:includes).with(:question_level, :user, :categories).and_return(@questions)
    end

    it "should assigns instance variable" do 
      send_request
      expect(assigns[:questions]).to eq(@questions)
    end

    it "should render template show_tag" do 
      send_request
      response.should render_template 'show_tag'
    end

    it "should_receive tagged_with" do 
      Question.should_receive(:tagged_with).with(tag.name, on: :tags).and_return(@questions)
      send_request
    end

    it "should_receive includes" do 
      @questions.should_receive(:includes).with(:question_level, :user, :categories).and_return(@questions)
      send_request
    end
  end

end
