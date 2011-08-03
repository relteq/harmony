module SimulationBatchesHelper
   
  def simulation_batch_select_options()
    return [
      ['Select Action ...' , ''],
      ['Generate Report' , 'generate']
    ]
  end
    
  def simulation_report_type_of_select_options
    return  [
     ['Compare vehicle types, single run' ],
     ['Aggregate Vehicle Types, Multiple Runs' ],
     ['Best/Worst case performance' ],
     ['Scatter plot'] 
    ]
  end

  def simulation_report_axis_network_select_options()
    return  [
     ['Network' , 'network'],
     ['Mainline' , 'mainline'],
     ['On-ramps' , 'on-ramps']
    ]
  end

  def simulation_report_axis_quantity_select_options()
    return  [
     ['Vehicle hours' , 'vehicle-hours'],
     ['Vehicle miles' , 'vehicle-miles'],
     ['Delay' , 'delay']
    ]
  end
  
  def check_box_for_sim(sim)
    check_box_tag("sim_ids[]", sim.id.to_s + ":" + sim.name, false, { 
      :id => sim.id.to_s + '-checkbox'
    })
  end
  
      
end
