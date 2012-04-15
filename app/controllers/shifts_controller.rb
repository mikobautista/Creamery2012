class ShiftsController < ApplicationController

  before_filter :check_login
  authorize_resource
  
 def index
    # get all the data on shifts in the system, 10 per page
    @shifts = Shift.chronological.paginate(:page => params[:page]).per_page(10)
  end

  def show
     # get data on that particular shift
    @shift = Shift.find(params[:id])
    @shiftjobs = @shift.shift_jobs.by_job
  end

  def new
    if params[:assignment_id]
      @shift = Shift.new(:assignment_id => params[:assignment_id])
    else
      @shift = Shift.new
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shift }
    end
  end

  def edit
    @shift = Shift.find(params[:id])
  end

  def create
    @shift = Shift.new(params[:shift])
    if @shift.save
      flash[:notice] = "Successfully created shift."
      redirect_to @shift
    else
      render :action => 'new'
    end
  end

  def update
    @shift = Shift.find(params[:id])
    if @shift.update_attributes(params[:shift])
      flash[:notice] = "Successfully updated shift."
      redirect_to shift_path(@shift)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @shift = Shift.find(params[:id])
    @shift.destroy
    flash[:notice] = "Successfully destroyed shift."
    redirect_to shifts_url
  end
end
