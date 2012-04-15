class HomeController < ApplicationController

  def index
    @stores = Store.active.alphabetical
    # obtain variables for the dashboards, depending on role of user
    if logged_in?
      if current_user.employee.role? == "admin"
        @top_employees = Employee.active.sort{|x,y| x.assignment_hours <=> y.assignment_hours}.last(5).reverse
      end
      if current_user.employee.role? == "manager" && !current_user.employee.current_assignment.nil?
        @employees = Employee.for_store(current_user.employee.current_assignment.store.id).where('end_date IS NULL').active.alphabetical.paginate(:page => params[:page]).per_page(10)
        @shifts = Shift.chronological
      end
      if current_user.employee.role? == "employee"
        @store = current_user.employee.current_assignment.nil? ? "No Current Assignment" : current_user.employee.current_assignment
        @completedshifts = Shift.by_employee.chronological.incomplete
      end
    end
  end

  def search
    # query used for the search bar in quick links
    @query = params[:query]
    if logged_in?
      if current_user.employee.role? == "admin"
        @employees = Employee.search(@query)
      elsif current_user.employee.role? == "manager"
        @employees = Employee.for_store(current_user.employee.current_assignment.store_id).search(@query)
      end
    @totalhits = @employees.size
    end
  end

  def show
    render :action => params[:page_type]
    @stores = Store.alphabetical
  end
end
