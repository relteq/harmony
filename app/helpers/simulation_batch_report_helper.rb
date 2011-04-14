module SimulationBatchReportHelper
  def simulation_report_export_select_options
    actions =  [
      ['Select Format ...' , ''],
      ['MS Powerpoint' , 'powerpoint'],
      ['PDF' , 'pdf']
    ]
  end
  
  def simulation_report_type_of_select_options
    actions =  [
      ['Select Type Of Report ...' , ''],
      ['Aggregate Vehicle Types, Multiple Runs' , 'powerpoint'],
      ['Type2' , 'type2']
    ]
  end
end
