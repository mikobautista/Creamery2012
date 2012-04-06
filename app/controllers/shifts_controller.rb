class ShiftsController < ApplicationController

 def index
    # get all the data on current shifts in the system, 10 per page
    @shifts = Shift.chronological.paginate(:page => params[:page]).per_page(10)
  end

  def show
     # get data on that particular shift
    @shift = Shift.find(params[:id])
  end

  def new
    @shift = Shift.new
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
      redirect_to @shift
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
