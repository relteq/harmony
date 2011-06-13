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

    context "time setting from string" do
      setup do
        @scenario = Scenario.generate!
      end
      should "set begin_time" do 
        @scenario.begin_time = "00h 01m 00.1s"
        assert_equal 60.1, @scenario.begin_time
      end
      should "set duration" do 
        @scenario.duration = "00h 01m 00.1s"
        assert_equal 60.1, @scenario.duration
      end
      should "set dt" do 
        @scenario.dt = "00h 01m 00.1s"
        assert_equal 60.1, @scenario.dt
      end
    end
  end
end
