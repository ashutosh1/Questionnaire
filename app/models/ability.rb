class Ability
  include CanCan::Ability

  def initialize(user)
    # CR_Priyank: alias_action can be out of initialize
    alias_action :create, :read, :update, :destroy, :to => :crud
    user ||= User.new    
    
    if user.has_role?(:super_admin)
      can :manage, :all
    elsif user.has_role?(:admin)
      can :manage, :all
      cannot :crud, User
    end
    
  end
end
