class ViewCustomizesController < ApplicationController
  layout 'admin'

  before_action :require_admin
  before_action :find_view_customize, :except => [:index, :new, :create, :update_all]

  helper :sort
  include SortHelper

  def index
    sort_init 'id', 'desc'
    sort_update %w(id path_pattern insertion_position customize_type code comments is_enabled is_private)
    @view_customizes = ViewCustomize.order(sort_clause)
  end

  def new
    @view_customize = ViewCustomize.new
  end

  def create
    @view_customize = ViewCustomize.new(view_customize_params)

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
    @view_customize.attributes = view_customize_params
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

  def update_all
    ViewCustomize.update_all(view_customize_params.to_hash)

    flash[:notice] = l(:notice_successful_update)
    redirect_to view_customizes_path
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

  def view_customize_params
    params.require(:view_customize)
      .permit(:path_pattern, :project_pattern, :customize_type, :code, :is_enabled, :is_private, :insertion_position, :comments)
  end
end
