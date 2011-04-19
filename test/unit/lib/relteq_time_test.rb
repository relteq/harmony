require File.expand_path('../../../test_helper', __FILE__)

class RelteqTimeTest < ActiveSupport::TestCase
  context "seconds from HMS" do
    context "with positive integral inputs" do
      should "work reasonably" do
        assert_equal 3600, RelteqTime.seconds_from_hms(1,0,0)
        assert_equal 60, RelteqTime.seconds_from_hms(0,1,0)
        assert_equal 1, RelteqTime.seconds_from_hms(0,0,1)
        assert_equal 7200, RelteqTime.seconds_from_hms(2,0,0)
        assert_equal 120, RelteqTime.seconds_from_hms(0,2,0)
        assert_equal 2, RelteqTime.seconds_from_hms(0,0,2)
        assert_equal 7322, RelteqTime.seconds_from_hms(2,2,2)
      end
    end
  end

  context "seconds to string" do
    context "with positive inputs" do
      should "work reasonably" do
        assert_equal "00h 00m 00.0s", RelteqTime.seconds_to_string(0)
        assert_equal "00h 00m 01.0s", RelteqTime.seconds_to_string(1)
        assert_equal "00h 00m 01.1s", RelteqTime.seconds_to_string(1.1)
        assert_equal "00h 00m 09.1s", RelteqTime.seconds_to_string(9.1)
        assert_equal "00h 00m 19.1s", RelteqTime.seconds_to_string(19.1)
        assert_equal "00h 01m 00.1s", RelteqTime.seconds_to_string(60.1)
        assert_equal "00h 01m 15.1s", RelteqTime.seconds_to_string(75.1)
        assert_equal "00h 11m 11.1s", RelteqTime.seconds_to_string(671.1)
        assert_equal "00h 59m 59.9s", RelteqTime.seconds_to_string(3599.9)
        assert_equal "01h 00m 00.1s", RelteqTime.seconds_to_string(3600.1)
        assert_equal "24h 00m 00.0s", RelteqTime.seconds_to_string(86400.0)
      end
    end
  end

  context "separate time" do
    context "with good input" do
      should "work reasonably" do
        assert_equal ['00','00','00.0'], RelteqTime.separate_time("00h 00m 00.0s")
        assert_equal ['00','00','01.0'], RelteqTime.separate_time("00h 00m 01.0s")
        assert_equal ['00','00','01.1'], RelteqTime.separate_time("00h 00m 01.1s")
        assert_equal ['00','00','11.1'], RelteqTime.separate_time("00h 00m 11.1s")
        assert_equal ['00','01','11.1'], RelteqTime.separate_time("00h 01m 11.1s")
        assert_equal ['00','11','11.1'], RelteqTime.separate_time("00h 11m 11.1s")
        assert_equal ['01','11','11.1'], RelteqTime.separate_time("01h 11m 11.1s")
        assert_equal ['11','11','11.1'], RelteqTime.separate_time("11h 11m 11.1s")
      end
    end
  end

  context "parse time to seconds" do
    context "with good input" do
      should "work reasonably" do
        assert_equal 0, RelteqTime.parse_time_to_seconds("00h 00m 00.0s")
        assert_equal 1, RelteqTime.parse_time_to_seconds("00h 00m 01.0s")
        assert_equal 1.1, RelteqTime.parse_time_to_seconds("00h 00m 01.1s")
        assert_equal 9.1, RelteqTime.parse_time_to_seconds("00h 00m 09.1s")
        assert_equal 19.1, RelteqTime.parse_time_to_seconds("00h 00m 19.1s")
        assert_equal 60.1, RelteqTime.parse_time_to_seconds("00h 01m 00.1s")
        assert_equal 75.1, RelteqTime.parse_time_to_seconds("00h 01m 15.1s")
        assert_equal 671.1, RelteqTime.parse_time_to_seconds("00h 11m 11.1s")
        assert_equal 3599.9, RelteqTime.parse_time_to_seconds("00h 59m 59.9s")
        assert_equal 3600.1, RelteqTime.parse_time_to_seconds("01h 00m 00.1s")
        assert_equal 86400.0, RelteqTime.parse_time_to_seconds("24h 00m 00.0s")
      end
    end
  end
end
