module SimulationBatchReportsHelper
  def js_nodes_array(nodes)
    list = nodes.map do |n|
      "[#{n.lat},#{n.lng}]"
    end.join(",")
    "[" + list + "]"
  end

  def simulation_batch_report_index_select_options
    return [
      ['Select Action ...' , '']
    ]
  end
end
