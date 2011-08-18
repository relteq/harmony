require File.expand_path('../../test_helper', __FILE__)

class SimulationBatchTest < ActiveSupport::TestCase
  
  context "A new simulation batch" do
    setup do
      @project =  Project.generate!
      @scenario = Scenario.generate!
      @project.scenarios << @scenario
      @sim_batch = SimulationBatch.generate!
      @scenario.simulation_batches << @sim_batch
      @user = User.generate!
      @sim_batch.creator = @user
    end
    
    should "return its current project" do
      assert_equal @project, @sim_batch.project
    end
    
    should "return its creator" do
      assert_equal @user, @sim_batch.creator
    end
  end
  
  context "The simulation batch" do
    setup do
      @sim_batch = SimulationBatch.generate!
    end
    
    should "be able to save itself" do
      new_sim_batch = SimulationBatch.save_batch({ :name => @sim_batch.name})
      assert_equal @sim_batch.name, new_sim_batch.name
      assert_equal @sim_batch.id, new_sim_batch.id - 1
    end
    
    should "be able to create itself" do
      assert_kind_of SimulationBatch, @sim_batch  
    end
    
  end
end
