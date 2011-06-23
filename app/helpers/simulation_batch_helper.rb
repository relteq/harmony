module SimulationBatchHelper
   
  def simulation_batch_select_options()
    return [
      ['Select Action ...' , ''],
      ['Generate Report' , 'generate'],
      ['Share' , 'share']
    ]
  end
  
  def simulation_report_type_of_select_options
    return  [
     ['Select Type Of Report ...' , ''],
     ['Compare vehicle types, single run' , 'Compare vehicle types, single run'],
     ['Aggregate Vehicle Types, Multiple Runs' , 'Aggregate Vehicle Types, Multiple Runs'],
     ['Best/Worst case performance' , 'Best/Worst case performance']
   #  ['Scatter plot' , 'Scatter plot']
     
    ]
  end

  def simulation_report_axis_network_select_options()
    return  [
     ['Network' , 'network'],
     ['Type2' , 'type2']
    ]
  end

  def simulation_report_axis_quantity_select_options()
    return  [
     ['Vehicle hours' , 'vehicle-hours'],
     ['Type2' , 'type2']
    ]
  end
end
