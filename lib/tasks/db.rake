namespace :db do
  task :drop_road_config => :environment do
    options = {}
    options['all'] = true if ENV['all']
    road_config_types = [Event, EventSet, 
                         Link, Route, Sensor, VehicleType,
                         InitialCondition, InitialConditionSet, Scenario,
                         DemandProfile, DemandProfileSet, CapacityProfile,
                         CapacityProfileSet, Controller, ControllerSet,
                         SplitRatioProfile, SplitRatioProfileSet,
                         RouteLink]
    if options['all']
      road_config_types.each do |model|
        puts "Destroying all #{model.name.pluralize}"
        model.all.each(&:destroy)
      end
    end
  end
end
