class Ability
  include CanCan::Ability


    # Define abilities for the passed in user here. For example:
    def initialize(user)
      user ||= User.new # Guest user (not logged in)

      if user.admin?
        can :manage, Bookmark
      elsif user.student?
        can :read, Bookmark
      end
      end
    end
