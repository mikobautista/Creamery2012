class StoresController < ApplicationController

  before_filter :check_login
  authorize_resource

  def index
    # get all the data on stores in the system, 10 per page
    @stores = Store.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
     # get data on that particular store
      @store = Store.find(params[:id])
      @stores = Store.all
  end

  def new
    @store = Store.new
  end

  def edit
    @store = Store.find(params[:id])
  end

  def create
    @store = Store.new(params[:store])
    if @store.save
      flash[:notice] = "Successfully created store."
      redirect_to @store
    else
      render :action => 'new'
    end
  end

  def update
    @store = Store.find(params[:id])
    if @store.update_attributes(params[:store])
      flash[:notice] = "Successfully updated store."
      redirect_to @store
    else
      render :action => 'edit'
    end
  end

  def destroy
    authorize! :destroy, @employee
    @store = Store.find(params[:id])
    @store.destroy
    flash[:notice] = "Successfully destroyed store."
    redirect_to stores_url
  end
end