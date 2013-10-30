require 'spec_helper'

describe RolesUser do 
  
  before(:each) do 
    @user = User.create(email: "ashutosh.tiwari@vinsol.com")
    @role = Role.new(name: User::ROLES.first)
    @user.roles << @role
    @roles_user = @user.roles_users
  end

  describe 'validation' do 
    it { should validate_uniqueness_of(:role_id).scoped_to(:user_id) }
  end
  
  describe "association" do 
    it { should belong_to(:user) }
    it { should belong_to(:role) }
  end
end