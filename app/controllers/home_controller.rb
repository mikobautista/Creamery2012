class HomeController < ApplicationController

  def index
    @stores = Store.active.alphabetical
    @top_employees = Employee.active.sort{|x,y| x.assignment_hours <=> y.assignment_hours}.last(5).reverse
    @employees = Employee.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @shifts = Shift.by_employee.chronological
    @completedshifts = Shift.by_employee.chronological.incomplete
  end

  def search
    @query = params[:query]
    @employees = Employee.search(@query)
    @total_hits = @employees.size
  end

  def show
    render :action => params[:page_type]
    @stores = Store.alphabetical
  end
end
