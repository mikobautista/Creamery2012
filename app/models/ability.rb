class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.employee.role? == "admin"
      can :manage, :all
      
    elsif user.employee.role? == "manager"
      can :manage, Shift do |shift|
        Shift.for_store(user.employee.store.id).include?(shift.id)
      end
      can :manage, Employee do |employee|
        employee.current_assignment.store_id == user.employee.current_assignment.store_id
      end
      
    elsif user.role == "employee"
      can :read, Shift do |shift|
        shift.id == user.employee.assignment.shift.id
      end
      can :update, Shift do |shift|
        shift.id == user.employee.assignment.shift.id
      end
    end
  end
  
end
