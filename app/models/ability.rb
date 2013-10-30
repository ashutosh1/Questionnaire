class Ability
  include CanCan::Ability

  def initialize(user)
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
