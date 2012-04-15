class EmployeesController < ApplicationController

  before_filter :check_login
  authorize_resource
  
  def index
    # get all the data on employees in the system, 10 per page
    if current_user.employee.role? == 'admin'
      @employees = Employee.alphabetical.paginate(:page => params[:page]).per_page(10)
    elsif current_user.employee.role? == 'manager'
      @employees = Employee.for_store(current_user.employee.current_assignment.store.id).where('end_date IS NULL').paginate(:page => params[:page]).per_page(10)
    else
      @employees = nil
    end
  end

  def show
    # get information on this particular employee
    @employee = Employee.find(params[:id])
  end

  def new
    @employee = Employee.new
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  def create
    @employee = Employee.new(params[:employee])
    if @employee.save
      flash[:notice] = "Successfully created employee."
      redirect_to @employee
    else
      render :action => 'new'
    end
  end

  def update
    @employee = Employee.find(params[:id])
    if @employee.update_attributes(params[:employee])
      flash[:notice] = "Successfully updated employee."
      redirect_to @employee
    else
      render :action => 'edit'
    end
  end

  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy
    flash[:notice] = "Successfully destroyed employee."
    redirect_to employees_url
  end
end