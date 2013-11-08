class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new    
    
    if user.has_role?(:super_admin)
      can :manage, :all
    elsif user.has_role?(:admin)
      can :manage, :all
      cannot :manage, User
    end
    
  end
end
