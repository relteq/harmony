class VehicleType < ActiveRecord::Base
  belongs_to :scenario
  validates_uniqueness_of :name, :scope => :scenario_id
  validates_numericality_of :weight, :greater_than => 0.0

  def short_display
    "#{name}/#{weight}"
  end
end
