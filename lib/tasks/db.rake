namespace :db do
  task :drop_road_config => :environment do
    options = {}
    options['all'] = true if ENV['all']
    road_config_types = [Event, EventSet, VehicleType,
                         InitialCondition, InitialConditionSet, Scenario,
                         DemandProfile, DemandProfileSet, CapacityProfile,
                         CapacityProfileSet, Controller, ControllerSet,
                         SplitRatioProfile, SplitRatioProfileSet, Network]
    ActiveRecord::Base.transaction do
      if options['all']
        road_config_types.each do |model|
          puts "Destroying all #{model.name.pluralize}"
          model.all.each(&:destroy)
        end
      end
    end
  end

  task :drop_simulation_data => :environment do
    SimulationBatch.all.each(&:destroy)
    SimulationBatchList.all.each(&:destroy)
    ReportedBatch.all.each(&:destroy)
    SimulationBatchReport.all.each(&:destroy)
  end

  task :drop_auths => :environment do
    puts "Destroying #{DbwebAuthorization.count} dbweb authorizations"
    DbwebAuthorization.all.each(&:destroy)
  end
end
