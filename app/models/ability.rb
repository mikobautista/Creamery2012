class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role? :admin
      can :manage, :all
    elsif user.role? :manager
      can :update, Shift do |shift|
        shift.id == user.shift_id
      end
      can :delete, Shift do |shift|
        shift.id == user.shift_id
      end
    elsif user.role? :member
      can:update, Shift do |shift|
        shift.id == user.shift_id
      end
    else
      can :read, :all
    end

  end
end
