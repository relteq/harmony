module SimulationBatchReportsHelper
  def js_nodes_array(routes)
    "[" +
      routes.map do |r_name, nodes| 
        list = nodes.map do |n|
          "[#{n.lat},#{n.lng}]"
        end.join(",")
        "{title: '#{r_name}', nodes: [" + list + "]}"
      end.join(",") +
    "]"
  end

  def simulation_batch_report_index_select_options
    return [
      ['Select Action ...' , '']
    ]
  end
end
