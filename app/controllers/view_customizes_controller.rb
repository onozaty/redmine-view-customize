class ViewCustomizesController < ApplicationController
  unloadable

  before_filter :require_admin

  def index
    @view_customizes = ViewCustomize.find(:all)
  end

  def new
    @view_customize = ViewCustomize.new()
  end

  def create
    @view_customize = ViewCustomize.new(params[:view_customize])

    if @view_customize.save    
      flash[:notice] = l(:notice_successful_create)
      redirect_to view_customize_path(@view_customize.id)
    else
      render :action => 'new'
    end
  end

  def show
  end

  def edit
  end
end
