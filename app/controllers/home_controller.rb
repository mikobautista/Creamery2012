class HomeController < ApplicationController

  def index
    render :action => params[:home] 
  end

  def show
    render :action => params[:page_type]
  end
end
