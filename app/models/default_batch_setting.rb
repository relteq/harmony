class DefaultBatchSetting < ActiveRecord::Base
  belongs_to :scenario
  
  def self.save_default_batch_settings(params)
    begin
      dbs = DefaultBatchSetting.find_by_scenario_id(params[:scenario_id]) 
    rescue ActiveRecord::RecordNotFound
     
    end
    
    dbs = DefaultBatchSetting.new if(dbs.nil?)
    dbs.number_of_runs =  params[:n_runs].to_i
    dbs.b_time = RelteqTime.parse_time_to_seconds(params[:begin_time])
    dbs.name = params[:name]
    dbs.mode = params[:mode]
    dbs.duration = RelteqTime.parse_time_to_seconds(params[:duration])
    dbs.control = params[:control]
    dbs.qcontrol = params[:qcontrol]
    dbs.events = params[:events]
    dbs.scenario_id = params[:scenario_id]
    dbs.save!
  end
  
end
