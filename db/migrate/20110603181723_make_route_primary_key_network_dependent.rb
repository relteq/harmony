class MakeRoutePrimaryKeyNetworkDependent < ActiveRecord::Migration
  def self.up
    execute %Q{
      CREATE TEMPORARY TABLE `routes_backup` (
        `id` INTEGER , `name` varchar(255), 
        `created_at` datetime, `updated_at` datetime, 
        `network_id` integer
      )
    }
    
    execute 'INSERT INTO `routes_backup` SELECT * FROM `routes`'
    execute 'DROP TABLE `routes`'
    execute %Q{
      CREATE TABLE `routes` (
        `network_id` integer NOT NULL,
        `id` INTEGER NOT NULL, `name` varchar(255), 
        `created_at` datetime, `updated_at` datetime, 
         PRIMARY KEY(`network_id`,`id`)
      )
    }
    execute %Q{
      INSERT INTO `routes` (SELECT `network_id`, `id`, 
        `name`, `created_at`, `updated_at` FROM `routes_backup`)
    }
  end

  def self.down
    throw ActiveRecord::Migration::Irreversible
  end
end
