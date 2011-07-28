class MeasurementDataController < ApplicationController
  helper :sort
  include SortHelper
  
  before_filter :require_project, :only => [:index,:create]
    
  def index
   
    sort_init 'name', 'asc'
    sort_update %w(name data_type data_format created_at user_id_creator)

    case params[:format]
    when 'xml', 'json'
      @offset, @limit = api_offset_and_limit      
    else
      @limit = per_page_option
    end
   

    @item_count = @project.measurement_data.count

    @item_pages = Paginator.new self, @item_count, @limit, params['page']
    @offset ||= @item_pages.current.offset
    @items_show = MeasurementDatum.find  :all,
                              :conditions => {:project_id => @project },
                              :order => sort_clause,
                              :limit  =>  @limit,
                              :offset =>  @offset

    auth = DbwebAuthorization.create_for(@project)
    @user = User.current
    @token = auth.access_token

    respond_to do |format|
      format.html { render :layout => !request.xhr? } # index.html.erb
      format.xml  { render :xml =>  @items_show}
    end
  end
  
  def create
    begin
      mdat = MeasurementDatum.new(params[:measurement_data])
      mdat.project_id = @project.id
      mdat.user_id_creator = User.current.id
    rescue
      flash[:error] = l(:measurement_data_not_successful_upload)    
    end 
    
    if(mdat.save)
        flash[:notice] = l(:measurement_data_successful_upload)
    else
        flash[:error] = mdat.errors.empty? ? l(:measurement_data_not_successful_upload) : mdat.errors.full_messages.to_sentence 
    end
    
    respond_to do |format|
      format.html { redirect_to project_measurement_data_path(@project) }
    end
  end
  
  def delete_file
    begin
      mdat =  MeasurementDatum.find(params[:id])
      mdat.destroy
      flash[:notice] = l(:measurement_datum) + ", '" + mdat.name + "', " + l(:label_success_delete)  
    rescue ActiveRecord::RecordNotFound
      flash[:error] = l(:measurement_datum_not_found)
    rescue
      flash[:error] = l(:measurement_datum_delete_not_success)
    end

    respond_to do |format|
      format.html { redirect_to project_measurement_data_path(params[:project_id]) }
    end 
  end

  def rename
    begin
       MeasurementDatum.save_rename(params[:measurement_data][:id],params[:measurement_data][:name])
      flash[:notice] = l(:notice_successful_update) 
    rescue ActiveRecord::RecordNotFound
      flash[:error] = l(:measurement_datum_not_found)
    rescue
      flash[:error] = l(:notice_update_not_successful)
    end
    
    respond_to do |format|
     format.html {  redirect_to project_measurement_data_path(params[:project_id])  } # index.html.erb     
    end
  end
  
  private
    def require_project
      begin
        @project = Project.find(params[:project_id])
      rescue ActiveRecord::RecordNotFound
        render :file => "#{Rails.root}/public/404.html", :status => 404
        return false
      end
    end
    
end