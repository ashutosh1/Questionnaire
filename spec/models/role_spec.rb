require 'spec_helper'

describe Role do 
  
  before(:each) do 
    @user = User.create(email: "ashutosh.tiwari@vinsol.com")
    @role = Role.new(name: User::ROLES.first)
  end

  describe 'validation' do 
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should ensure_inclusion_of(:name).in_array(User::ROLES).with_low_message("%{value} is not a valid role") }
  end
  
  describe "association" do 
    it { should have_many(:roles_users) }
    it { should have_many(:users).through(:roles_users) }
  end
end