require 'lib/export-report-gen/export'

class SimulationBatchReport < ActiveRecord::Base
  include RelteqTime::ActiveRecordMethods
  include SimulationBatchReportExporter
  
  
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
end
