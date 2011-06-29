class SimulationBatchReport < ActiveRecord::Base
  include RelteqTime::ActiveRecordMethods
  
  relteq_time_attr :b_time
  relteq_time_attr :duration
  
  belongs_to :simulation_batch_list
  
  belongs_to :scatter_plot
  belongs_to :color_pallette
  

  def colors
    "#69A7D6,#980D92,#D32A64,#707826,#DFD555,#E17A8F,#2B478E,#4CDA1D,#F432C6,#07CAFF,#1C9F22"
  end
    
  def format_creation_time
     creation_time.strftime("%m/%d/%Y at %I:%M%p") if !(creation_time.nil?)
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

    #These are used for ScaterPlots and ScatterGroups in 
    #report generator. Will add when we get there.
    #@simulation_batches = Array.new
    #@scenarios = Array.new
    # begin
    #    params[:sim_ids].each do |s|
    #      sb = SimulationBatch.find_by_id(s)
    #      @simulation_batches.push(sb)
    #      @scenarios.push(Scenario.find_by_id(sb.scenario_id))
    #    end
    #  rescue NoMethodError
    # 
    #  end

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
        xml.report_id self.id
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
        xml.cbx_boxplot false
        xml.colors self.colors
        xml.tbl_groups ""
        scen_names = ""
        xml.tbl_scenariogroups{
          self.simulation_batch_list.simulation_batches.each do |sb|
            xml.entry(:scenario => sb.scenario.name, :group => "")
            scen_names += sb.scenario.name + ","      
          end

        }
        
        xml.cmb_xaxis_subnetwork(:selected => "0") {"Network,Onramps,Mainline"}
        xml.cmb_xaxis_quantity(:selected => "0") {"Vehicle hours,Vehicle miles,Delay"}
        xml.cmb_yaxis_subnetwork(:selected => "0") {"Network,Onramps,Mainline"}
        xml.cmb_yaxis_quantity(:selected => "0") {"Vehicle hours,Vehicle miles,Delay"}
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
end
