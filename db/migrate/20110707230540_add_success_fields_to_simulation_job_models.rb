class AddSuccessFieldsToSimulationJobModels < ActiveRecord::Migration
  def self.up
    add_column :simulation_batches, :succeeded, :boolean
    add_column :simulation_batch_reports, :succeeded, :boolean
    
    add_column :simulation_batches, :failure_message, :string
    add_column :simulation_batch_reports, :failure_message, :string
  end

  def self.down
    remove_column :simulation_batches, :succeeded
    remove_column :simulation_batch_reports, :succeeded
    
    remove_column :simulation_batches, :failure_message
    remove_column :simulation_batch_reports, :failure_message
  end
end
