class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    
    # Administrators have god-like powers and can do anything.
    if user.employee.role? == "admin"
      can :manage, :all
    
    # Managers have access to edit information on themselves and any employee assigned to their store.
    # They can also create and edit shifts of these employees.
    elsif user.employee.role? == "manager"
      can :manage, Shift do |shift|
        Shift.for_store(user.employee.store.id).include?(shift.id)
      end
      can :manage, Employee do |employee|
        employee.current_assignment.store_id == user.employee.current_assignment.store_id
      end
      
    # Employees can only see their own information, and have read-only access.
    elsif user.role == "employee"
      can :read, Shift do |shift|
        shift.id == user.employee.assignment.shift.id
      end
    end
  end
  
end
