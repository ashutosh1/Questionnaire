require 'spec_helper'

describe Option do 

  before(:each) do 
    @user = User.create(email: "ashutosh.tiwari@vinsol.com")
    @option = Option.new(question_id: 1, option: "test")
  end

  describe 'validation' do 
    it { should validate_presence_of(:option) }
  end

  describe "association" do 
    it { should belong_to(:question) }
  end

  describe "scpoe subjective_answers" do
    context "subjective_answers not present" do 
      it "should return blank" do 
        Option.subjective_answers.should eq([])
      end
    end

    context "subjective_answers present" do 
      before do 
        @option1 = Option.create(option: "abc", answer: nil, question_id: 1)
      end
      it "should return options with answer nil" do 
        Option.subjective_answers.should eq([@option1])
      end
    end
  end  

  describe "scpoe mcq_answer" do
    context "mcq_answer not present" do 
      it "should return blank" do 
        Option.mcq_answer.should eq([])
      end
    end

    context "mcq_answer present" do 
      context "answer is true" do 
        before do 
          @option1 = Option.create(option: "abc", answer: true, question_id: 1)
        end
        it "should return options with answer nil" do 
          Option.mcq_answer.should eq([@option1])
        end
      end

      context "answer is false" do 
        before do 
          @option1 = Option.create(option: "abc", answer: false, question_id: 1)
        end
        it "should return options with answer nil" do 
          Option.mcq_answer.should eq([])
        end
      end
    end
  end

end