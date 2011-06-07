class MakeLinkPrimaryKeyNetworkDependentChangeColumnNames < ActiveRecord::Migration
  def self.up
    execute %Q{
      CREATE TEMPORARY TABLE `links_backup` (
        `id` INTEGER NOT NULL, `type_link` varchar(255), 
        `name` text(255), `length` decimal, `lanes` decimal, 
        `created_at` datetime, `updated_at` datetime, `network_id` integer, 
        `begin_node_id` integer, `end_node_id` integer, 
        `begin_node_order` integer, `end_node_order` integer, 
        `qmax` decimal, `fd` varchar(255), `weaving_factors` varchar(255),
        `description` varchar(255)
      )
    }
    
    execute 'INSERT INTO `links_backup` SELECT * FROM `links`'
    execute 'DROP TABLE `links`'
    execute %Q{
      CREATE TABLE `links` (
        `network_id` integer NOT NULL, 
        `id` INTEGER NOT NULL REFERENCES `link_families`, 
        `type_link` varchar(255), 
        `name` text(255), `length` decimal, `lanes` decimal, 
        `created_at` datetime, `updated_at` datetime, 
        `begin_id` integer NOT NULL, `end_id` integer NOT NULL, 
        `begin_order` integer, `end_order` integer, 
        `qmax` decimal(10,5), `fd` varchar(255), `weaving_factors` varchar(255),
        `description` varchar(255),
        PRIMARY KEY(`network_id`,`id`),
        FOREIGN KEY(`network_id`) REFERENCES `networks`(`id`),
        FOREIGN KEY(`network_id`,`begin_id`) REFERENCES `nodes`(`network_id`,`id`),
        FOREIGN KEY(`network_id`,`end_id`) REFERENCES `nodes`(`network_id`,`id`)
      )
    }
    # Can't use * because we're switching column order
    execute %Q{
      INSERT INTO `links` (SELECT `network_id`, `id`, `type_link`,
        `name`, `length`, `lanes`, `created_at`, `updated_at`, `begin_node_id`,
        `end_node_id`, `begin_node_order`, `end_node_order`, `qmax`, `fd`,
        `weaving_factors`, `description` FROM `links_backup`)
    }
  end

  def self.down
    throw ActiveRecord::Migration::Irreversible
  end
end
