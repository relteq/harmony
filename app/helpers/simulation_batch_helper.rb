module SimulationBatchHelper
   
  def simulation_batch_select_options()
    actions =  [
      ['Select Action ...' , ''],
      ['Generate Report' , 'generate'],
      ['Share' , 'share'],
      ['Export XML' , 'export'],
      ['Rename' , 'rename'],
      ['Delete' , 'delete']
    ]
  end
end
