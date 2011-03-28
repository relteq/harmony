class CreateSimulationBatchReports < ActiveRecord::Migration
  def self.up
    create_table :simulation_batch_reports do |t|
      t.integer :simulation_batch_list_id
      t.string :name
      t.decimal :b_time
      t.decimal :duration
      t.boolean :network_pref
      t.boolean :link_pref
      t.boolean :or_pref_t
      t.boolean :or_pref_s
      t.boolean :or_pref_c
      t.boolean :route_pref_t
      t.boolean :route_pref_s
      t.boolean :route_pref_c
      t.boolean :route_tt_t
      t.boolean :route_tt_c
      t.decimal :congestion_speed
      t.integer :max_data_points
      t.boolean :fill_plots
      t.boolean :legend
      t.datetime :creation_time
      t.decimal :execution_time
      t.decimal :percent_complete
      t.binary :cpu_instance

      t.timestamps
    end
  end

  def self.down
    drop_table :simulation_batch_reports
  end
end
