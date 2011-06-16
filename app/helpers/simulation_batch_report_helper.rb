module SimulationBatchReportHelper

  def simulation_batch_report_index_select_options()   
      return [
        ['Select Action ...' , ''],
        ['Share' , 'share'],
        ['Export XML' , 'export'],
        ['Export PDF' , 'pdf'],
        ['Export XLS' , 'xls'],
        ['Export PPT' , 'ppt'],
        ['Rename' , 'rename'],
        ['Delete' , 'delete']
      ]
   end
  
end
