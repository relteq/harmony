class RenameColumnsSimulationBatchReport < ActiveRecord::Migration
  def self.up
    rename_column :simulation_batch_reports, :network_pref, :network_perf
    rename_column :simulation_batch_reports, :link_pref, :link_perf
    rename_column :simulation_batch_reports, :or_pref_t,  :or_perf_t
    rename_column :simulation_batch_reports, :or_pref_s, :or_perf_s
    rename_column :simulation_batch_reports, :or_pref_c, :or_perf_c
    rename_column :simulation_batch_reports, :route_pref_t, :route_perf_t
    rename_column :simulation_batch_reports, :route_pref_s, :route_perf_s
    rename_column :simulation_batch_reports, :route_pref_c, :route_perf_c
  end

  def self.down
    rename_column :simulation_batch_reports, :network_perf, :network_pref
    rename_column :simulation_batch_reports, :link_perf, :link_pref
    rename_column :simulation_batch_reports, :or_perf_t,  :or_pref_t
    rename_column :simulation_batch_reports, :or_perf_s, :or_pref_s
    rename_column :simulation_batch_reports, :or_perf_c, :or_pref_c
    rename_column :simulation_batch_reports, :route_perf_t, :route_pref_t
    rename_column :simulation_batch_reports, :route_perf_s, :route_pref_s
    rename_column :simulation_batch_reports, :route_perf_c, :route_pref_c
  end
end
