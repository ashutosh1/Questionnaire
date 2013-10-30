require 'spec_helper'

describe User do 
  
  it_should 'send email to user after creation'
  it_should 'find for google oauth verification'
  
  before(:each) do 
    @user = User.create(email: "ashutosh.tiwari@vinsol.com")
    @role = Role.create(name: User::ROLES.first)
    @user.roles << @role
  end

  describe 'validation' do 
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value('test@example.com').for(:email ) }
    it { should allow_value('test@example.co.in').for(:email ) }
    it { should_not allow_value('test@example').for(:email ) }
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

end