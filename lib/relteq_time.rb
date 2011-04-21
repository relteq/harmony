module RelteqTime
  # WARNING - right now ADDITIONAL_MASKED_FIELDS doesn't get mapped out, 
  # changing the fields requires editing of
  # public/javascripts/prototype.maskedinput.js. I think it would be a good
  # idea to automatically generate that JS code in the future.
  ADDITIONAL_MASKED_FIELDS = { '5' => '[0-5]' }
  MASKED_INPUT_REPRESENTATION = "99h 59m 59.9s"
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

  def self.mask
    MASKED_INPUT_REPRESENTATION
  end

  module ActiveRecordMethods
    Parent = RelteqTime
  public
    module ClassMethods
      def relteq_time_attr(attr, base = self)
        attr_sym = attr.to_s
        punctuated_attr_sym = (attr_sym.to_s + '=').to_sym
        define_method punctuated_attr_sym,
                      relteq_time_attr_setter_string_wrap(attr_sym)
      end

      def relteq_time_attr_setter_string_wrap(raw_attr)
        Proc.new do |val|
          if val.is_a?(String)
            write_attribute(raw_attr, Parent.parse_time_to_seconds(val))
          else
            write_attribute(raw_attr, val)
          end
        end
      end
    end

    def display_time(sym)
      Parent.seconds_to_string(self.send(sym) || 0.0)
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
