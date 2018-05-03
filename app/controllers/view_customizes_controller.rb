class ViewCustomizesController < ApplicationController
  unloadable

  layout 'admin'

  before_filter :require_admin
  before_filter :find_view_customize, :except => [:index, :new, :create]

  helper :sort
  include SortHelper

  def index
    sort_init 'id', 'desc'
    sort_update %w(id path_pattern customize_type code is_enabled is_private)
    @view_customizes = ViewCustomize.all.order(sort_clause)
  end

  def new
    @view_customize = ViewCustomize.new
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

  def update
    @view_customize.attributes = params[:view_customize]
    if @view_customize.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to view_customize_path(@view_customize.id)
    else
      render :action => 'edit'
    end
  rescue ActiveRecord::StaleObjectError
    flash.now[:error] = l(:notice_locking_conflict)
    render :action => 'edit'
  end

  def destroy
    @view_customize.destroy
    redirect_to view_customizes_path
  end

  private

  def find_view_customize
    @view_customize = ViewCustomize.find(params[:id])
    render_404 unless @view_customize
  end

end
