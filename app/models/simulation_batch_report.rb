class SimulationBatchReport < ActiveRecord::Base
  include RelteqTime::ActiveRecordMethods
  include RelteqUserStamps
 
  named_scope :incomplete, :conditions => ['percent_complete < 1 OR (NOT succeeded)']
  named_scope :complete, :conditions => ['percent_complete = 1 AND succeeded']
 
  relteq_time_attr :b_time
  relteq_time_attr :duration
  
  belongs_to :simulation_batch_list
  
  belongs_to :scatter_plot
  belongs_to :color_pallette

  before_destroy :delete_associated_s3_data

  def project
    simulation_batch_list.simulation_batches.first.project
  end
  
  def mode
    'Create Report'
  end

  def start_time
    created_at
  end

  def colors
    "#69A7D6,#980D92,#D32A64,#707826,#DFD555,#E17A8F,#2B478E,#4CDA1D,#F432C6,#07CAFF,#1C9F22"
  end
    
  def format_creation_time
     creation_time.strftime("%m/%d/%Y at %I:%M%p") if !(creation_time.nil?)
  end

  def export_xls_url
    AWS::S3::S3Object.url_for(xls_key, s3_bucket) if !(s3_bucket.nil?)
  end

  def export_pdf_url
    AWS::S3::S3Object.url_for(pdf_key, s3_bucket) if !(s3_bucket.nil?)
  end

  def export_xml_url
    AWS::S3::S3Object.url_for(xml_key, s3_bucket) if !(s3_bucket.nil?)
  end

  def export_ppt_url
    AWS::S3::S3Object.url_for(ppt_key, s3_bucket) if !(s3_bucket.nil?)
  end
  
  #this is used to populate the Report Generator form
  #with default values
  def default_report_settings!

    #set up default values
    self.network_perf = true
    self.network_perf = true
    self.route_perf_t = true
    self.route_tt_t = true
    self.route_perf_c = true
    self.route_tt_c  = true
    self.duration  = 86400
  end
  
  
  def self.get_simuation_batch_lists(project)
    sim_lists = Array.new
    project.scenarios.each do |s|
      s.simulation_batches.each do |sb|
        sb.reported_batches.each do |rb|
          sim_lists.push(rb.simulation_batch_list)
        end
      end
    end
    sim_lists
  end
  
  #once the report is made we need to tie the
  #reports to the simulation batches used to create the report
  #This done via the Simulation Batch List and reported_batches table
  def link_to_simulation_batches(sim_ids)
    sbl = SimulationBatchList.new
    sbl.save!
    self.simulation_batch_list_id = sbl.id
    self.save!
    sim_ids.each do |s|
      rb = ReportedBatch.new
      rb.simulation_batch_id = s
      rb.simulation_batch_list_id =  self.simulation_batch_list_id
      rb.save!
    end
  end
  
  def to_xml
    builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
      xml.guidata {
        xml.cmb_export "PDF"
        xml.cmb_reporttype self.report_type
        xml.txt_congspeed self.congestion_speed
        xml.txt_maxpointspercurve self.max_data_points
        xml.cbx_orperf_time self.or_perf_t
        xml.cbx_orperf_space self.or_perf_s
        xml.cbx_orperf_contour self.or_perf_c
        xml.cbx_routeperf_time self.route_perf_t
        xml.cbx_routeperf_space self.route_perf_s
        xml.cbx_routeperf_contour self.route_perf_c
        xml.cbx_routetraveltime self.route_tt_t
        xml.cbx_routetrajectories self.route_tt_c
        xml.cbx_dolegend self.legend
        xml.cbx_dofill self.fill_plots
        xml.cbx_linkstate self.link_perf
        xml.cbx_sysperf self.network_perf
        xml.outputfile ""
        xml.txt_timefrom self.b_time
        xml.txt_timeto self.duration
        xml.txt_customxaxis ""
        xml.cbx_boxplot self.scatter_plot.box_plot
        xml.colors self.colors
        xml.tbl_groups ""
        scen_names = ""
        xml.tbl_scenariogroups{
          self.simulation_batch_list.simulation_batches.each do |sb|
            xml.entry(:scenario => sb.scenario.name, :group => "")
            scen_names += sb.scenario.name + ","      
          end

        }
        
        xml.cmb_xaxis_subnetwork self.scatter_plot.x_axis_type
        xml.cmb_xaxis_quantity self.scatter_plot.x_axis_quantity
        xml.cmb_yaxis_subnetwork self.scatter_plot.y_axis_type
        xml.cmb_yaxis_quantity self.scatter_plot.y_axis_quantity
        xml.scenarios_old scen_names[0,scen_names.length-1]
        xml.datafiles_old ""
        xml.BatchList {
          self.simulation_batch_list.simulation_batches.each do |sb|
            xml.batch(:name => sb.scenario.name){
              sb.output_files.each do |f|
                xml.data_file(:url => f.url)
              end
            }
          end
        }
      }
    end
    builder.to_xml
  end
  
  def creator
    begin
      User.find(user_id_creator)
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end
  
private
  def delete_associated_s3_data
    [xls_key, pdf_key, ppt_key, xml_key].each do |key|
      AWS::S3::S3Object.delete(key, s3_bucket) if key
    end
  end
end
