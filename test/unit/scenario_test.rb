require File.expand_path('../../test_helper', __FILE__)

class ScenarioTest < ActiveSupport::TestCase
  context "with network, project, name" do
    setup do
      @project = Project.generate!
      @network = Network.generate!
      @project.networks << @network
    end

    should "create a default vehicle type with new scenario" do
      VehicleType.destroy_all
      @scenario = @network.scenarios.create(:project => @project, 
                                            :name => 'test')
      assert_equal 1, @scenario.vehicle_types.count
      assert_equal 'General', @scenario.vehicle_types[0].name
      assert_equal 1.0, @scenario.vehicle_types[0].weight
    end
  end
end
