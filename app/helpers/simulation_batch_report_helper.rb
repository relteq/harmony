module SimulationBatchReportHelper

  def simulation_batch__report_index_select_options()   
     return [
       ['Select Action ...' , ''],
       ['Share' , 'share'],
       ['Export XML' , 'export'],
       ['Export PDF' , 'pdf'],
       ['Rename' , 'rename'],
       ['Delete' , 'delete']
     ]
  end
   
  def simulation_report_export_select_options
    return  [
      ['Select Format ...' , ''],
      ['MS Powerpoint' , 'powerpoint'],
      ['PDF' , 'pdf']
    ]
  end
  
  def simulation_report_type_of_select_options
    return  [
      ['Select Type Of Report ...' , ''],
      ['Aggregate Vehicle Types, Multiple Runs' , 'powerpoint'],
      ['Type2' , 'type2']
    ]
  end
end
