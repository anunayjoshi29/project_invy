# handle roles here
class Ability
    include CanCan::Ability
  
    def initialize(user)
      user ||= User.new
      if user.admin?
        can :manage, :all
      elsif user.staff?
        can :read, Schedule
        can :read, User
      end
    end
  end
  