require 'app/models/simulation_batch_list'
require 'app/models/reported_batch'
require 'app/models/simulation_batch'
require 'app/models/scenario'
require 'app/models/output_file'

module SimulationBatchReportExporter
    def to_xml
      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.guidata{
          xml.cmb_export "PDF"
          xml.cmb_reporttype self.name
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
            self.simulation_batch_list.reported_batches.each do |r|
              xml.entry(:scenario => r.simulation_batch.scenario.name, :group => "")
              scen_names += r.simulation_batch.scenario.name + ","      
            end
  
          }
          
          xml.cmb_xaxis_subnetwork(:selected => "0") {"Network,Onramps,Mainline"}
        	xml.cmb_xaxis_quantity(:selected => "0") {"Vehicle hours,Vehicle miles,Delay"}
        	xml.cmb_yaxis_subnetwork(:selected => "0") {"Network,Onramps,Mainline"}
        	xml.cmb_yaxis_quantity(:selected => "0") {"Vehicle hours,Vehicle miles,Delay"}
        	xml.scenarios_old scen_names[0,scen_names.length-1]
        	xml.datafiles_old ""
        	xml.BatchList {
        	  self.simulation_batch_list.reported_batches.each do |r|
              xml.batch(:name => r.simulation_batch.scenario.name){
                r.simulation_batch.output_files.each do |f|
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

	


