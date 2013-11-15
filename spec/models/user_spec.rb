require 'spec_helper'

describe User do 
  
  it_should 'send email to user after creation'
  it_should 'find for google oauth verification'
  it_should 'should add audit callbacks'
  
  before(:each) do 
    @user = User.create(email: "ashutosh.tiwari@vinsol.com")
    @role = Role.create(name: User::ROLES.first)
    @role2 = Role.create(name: User::ROLES.last)
    @user.roles << @role
    @roles_user1 = @user.roles_users.first
    @roles_user2 = RolesUser.create(user_id: @user.id, role_id: @role.id)
  end

  describe 'validation' do 
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value('test@vinsol.com').for(:email ) }
    it { should allow_value('test@vinsol.com').for(:email ) }
    it { should_not allow_value('test@example.com').for(:email ) }
    it { should_not allow_value('test@yahoo.com').for(:email ) }
  end

  describe "association" do 
    it { should have_many(:roles_users).dependent(:destroy) }
    it { should have_many(:roles).through(:roles_users) }
    it { should have_many(:questions) }
  end

  describe "accept_nested_attributes_for" do 
    it { should accept_nested_attributes_for(:roles_users).allow_destroy(true) }
  end

  describe "attr_readonly email" do 
    it { should have_readonly_attribute(:email) }
  end

  describe "constant ROLES" do 
    it "should eq to %w[super_admin admin]" do
      User::ROLES.should eq(%w[super_admin admin])
    end
  end

  describe "#has_role?" do 
    it "should return false if has_role" do 
      @user.has_role?(:admin).should eq(false)
    end

    it "should return true if has_role" do 
      @user.has_role?(:super_admin).should eq(true)
    end
  end

  describe "#build_roles_users" do 
    before do
      @user.stub(:roles_users).and_return([@roles_user1])
      Role.stub(:where).with(["id NOT IN (?)", [@role.id]]).and_return([@role2])
      @role2.stub(:roles_users).and_return(@roles_user2)
      @roles_user2.stub(:build).and_return(@roles_user2)
      @roles_user1.stub(:build).and_return(@roles_user1)
      Role.stub(:all).and_return([@role, @role2])
    end

    describe "should_receive methods" do 

      it "should_receive roles_users" do 
        @user.should_receive(:roles_users).twice.and_return([@roles_user1])
      end

      it "Role should_receive where" do 
        Role.should_receive(:where).with(["id NOT IN (?)", [@role.id]]).and_return([@role2])
      end

      it "should_receive roles_users" do 
        @role2.should_receive(:roles_users).and_return(@roles_user2)
      end

      it "should_receive build" do 
        @roles_user2.should_receive(:build).and_return(@roles_user2)
      end

      after do 
        @user.build_roles_users
      end
    end

    context "user has no roles" do 
      before do 
        @user.stub(:roles_users).and_return([])
        Role.stub(:where).with(["id NOT IN (?)", []]).and_return([])
        @role.stub(:roles_users).and_return(@roles_user1)
        @roles_user1.stub(:build).and_return(@roles_user1)
        @role2.stub(:roles_users).and_return(@roles_user2)
        @roles_user2.stub(:build).and_return(@roles_user2)
      end
      describe "should_receive methods" do 

        it "Role should_receive all" do 
          Role.should_receive(:all).and_return([@role, @role2])
        end

        it "role1 should_receive roles_users" do 
          @role.should_receive(:roles_users).and_return(@roles_user1)
        end

        it "roles_user1 should_receive build" do 
          @roles_user1.should_receive(:build).and_return(@roles_user1)
        end

        it "role2 should_receive roles_users" do 
          @role2.should_receive(:roles_users).and_return(@roles_user2)
        end

        it "roles_user2 should_receive build" do 
          @roles_user2.should_receive(:build).and_return(@roles_user2)
        end

        after do 
          @user.build_roles_users
        end
      end
    end

    context "user has roles" do 
      it "Role should_not_receive all" do 
        Role.should_not_receive(:all)
      end

      it "role1 should_not_receive roles_users" do 
        @role.should_not_receive(:roles_users)
      end

      it "roles_user1 should_not_receive build" do 
        @roles_user1.should_not_receive(:build)
      end

      after do 
        @user.build_roles_users
      end
    end
  end

end