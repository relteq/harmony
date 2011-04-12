require File.expand_path('../../test_helper', __FILE__)

class VehicleTypeTest < ActiveSupport::TestCase
  context "with valid VehicleType" do
    setup do
      @vehicle_type = VehicleType.generate!(:name => '@name', :weight => 0.5)
    end

    should "short_display as name/weight" do
      assert_equal '@name/0.5', @vehicle_type.short_display
    end
  end
end
