shared_examples_for 'should add audit callbacks' do 
  
  describe "callbacks" do 
    it "should add a after_create callbacks" do 
      described_class._create_callbacks.select { |cb| cb.kind.eql?(:after) }.collect(&:filter).include?(:record_create).should eq(true)
    end

    it "should add a before_update callbacks" do 
      described_class._update_callbacks.select { |cb| cb.kind.eql?(:before) }.collect(&:filter).include?(:record_update).should eq(true)
    end
    
    it "should add a after_destroy callbacks" do 
      described_class._destroy_callbacks.select { |cb| cb.kind.eql?(:after) }.collect(&:filter).include?(:record_destroy).should eq(true)
    end


  end
end
