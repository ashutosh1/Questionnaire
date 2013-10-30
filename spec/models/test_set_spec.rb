require 'spec_helper'

describe TestSet do 
  let(:test_set) {mock_model(TestSet)}
  
  
  describe "association" do 
    it { should have_and_belong_to_many(:questions) }
  end
end