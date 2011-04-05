class VehicleType < ActiveRecord::Base
  generator_for :weight, :method => :next_weight

  def self.next_weight
    @last_weight ||= 0.0
    @last_weight += 0.1
    @last_weight
  end
end
