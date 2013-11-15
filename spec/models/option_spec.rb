require 'spec_helper'

describe Option do 

  it_should 'should add audit callbacks'

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

end
