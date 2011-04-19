module RelteqTime
  MASKED_INPUT_REPRESENTATION = "99h 59m 59s"
  REGEX_REPRESENTATION = /(\d\d)h (\d\d)m (\d\d\.\d)s/
  PRINTF_REPRESENTATION = "%02dh %02dm %04.1fs"

public
  def self.seconds_from_hms(h,m,s)
    3600*h + 60*m + s
  end

  # There could be some rounding error here, if seconds stays
  # as a float
  def self.seconds_to_string(s)
    s_i = s.to_i
    hours = s_i / 3600
    minutes = (s_i % 3600) / 60
    seconds = s - (hours * 3600) - (minutes * 60)
    sprintf PRINTF_REPRESENTATION, hours, minutes, seconds
  end

  def self.separate_time(str)
    if is_valid_time?(str)
      str =~ REGEX_REPRESENTATION
    end
    [$1, $2, $3] 
  end

  def self.parse_time_to_seconds(str)
    h,m,s = separate_time(str)
    seconds_from_hms(h.to_f,m.to_f,s.to_f)
  end

  def self.is_valid_time?(str)
    str =~ REGEX_REPRESENTATION
  end

  def self.zero_time_string
    seconds_to_string(0)
  end

  def display_time(sym)
    RelteqTime.seconds_to_string(self.send(sym) || 0.0)
  end
end
