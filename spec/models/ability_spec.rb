require 'spec_helper'
require "cancan/matchers"

describe Ability do 
  
  before(:each) do 
    @user1 = User.create(email: "ashutosh.tiwari@vinsol.com")
    @user2 = User.create(email: "test@vinsol.com")
    @role1 = Role.create(name: User::ROLES.first)
    @role2 = Role.create(name: User::ROLES.last)
    @user1.roles << @role1
    @user2.roles << @role2
    @user3 = User.create(email: "test2@vinsol.com")
  end


  describe 'Abilities' do 
    
    context "super admin" do 
      before do 
        @ability = Ability.new(@user1)
      end

      it "should able to manage everything" do 
        @ability.should be_able_to(:manage, :all)
      end
    end

    context "user admin" do
      before do 
        @ability = Ability.new(@user2)
      end

      it "should able to manage everything" do 
        @ability.should be_able_to(:manage, :all)
      end

      it "should able to crud user" do 
        @ability.should_not be_able_to(:crud, User)
      end
    end

    context "other user" do 
      before do 
        @ability = Ability.new(@user3)
      end

      it "should able to crud user" do 
        @ability.should_not be_able_to(:crud, User)
      end

      it "should able to crud user" do 
        @ability.should_not be_able_to(:manage, :all)
      end
    end
  end
end