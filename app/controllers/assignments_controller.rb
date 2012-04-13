class AssignmentsController < ApplicationController

  before_filter :check_login
  authorize_resource

  def index
    # get all the data on current assignments in the system, 10 per page
    @assignments = Assignment.by_employee.by_store.paginate(:page => params[:page]).per_page(10)
  end

  def show
     # get data on that particular assignment
      @assignment = Assignment.find(params[:id])
  end

  def new
    if params[:store_id]
      @assignment = Assignment.new(:store_id => params[:store_id])
    elsif params[:employee_id]
      @assignment = Assignment.new(:employee_id => params[:employee_id])
    else
      @assignment = Assignment.new
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @assignment }
    end
  end

  def edit
    @assignment = Assignment.find(params[:id])
  end

  def create
    @assignment = Assignment.new(params[:assignment])
    if @assignment.save
      flash[:notice] = "Successfully created assignment."
      redirect_to @assignment
    else
      render :action => 'new'
    end
  end

  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update_attributes(params[:assignment])
      flash[:notice] = "Successfully updated assignment."
      redirect_to @assignment
    else
      render :action => 'edit'
    end
  end

  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.destroy
    flash[:notice] = "Successfully destroyed assignment."
    redirect_to assignments_url
  end
end