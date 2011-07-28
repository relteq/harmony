class MeasurementDataController < ApplicationController
  helper :sort
  include SortHelper
  
  def index
   
    sort_init 'name', 'asc'
    sort_update %w(name file_type file_format created_at user_id_creator)

    case params[:format]
    when 'xml', 'json'
      @offset, @limit = api_offset_and_limit      
    else
      @limit = per_page_option
    end
   
    begin
      @project = Project.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      render :file => "#{Rails.root}/public/404.html", :status => 404
      return false
    end

    @item_count = @project.measurement_data.count

    @item_pages = Paginator.new self, @item_count, @limit, params['page']
    @offset ||= @item_pages.current.offset
    @items_show = MeasurementDatum.find  :all,
                              :conditions => {:project_id => @project },
                              :order => sort_clause,
                              :limit  =>  @limit,
                              :offset =>  @offset

#    auth = DbwebAuthorization.create_for(@project)
    @user = User.current
#    @token = auth.access_token

    respond_to do |format|
      format.html { render :layout => !request.xhr? } # index.html.erb
      format.xml  { render :xml =>  @items_show}
    end
  end


end
