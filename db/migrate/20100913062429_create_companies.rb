class CreateCompanies < ActiveRecord::Migration
  def self.up

    execute %Q(
           Create table `companies` (
          `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
          `name` varchar(50) NOT NULL,
          `website` varchar(50) NOT NULL,
          `address1` varchar(50) NOT NULL,
          `address2` varchar(50) DEFAULT NULL,
          `city` varchar(30) NOT NULL,
          `state` varchar(30) NOT NULL,
          `zipcode` varchar(10) NOT NULL,
          `latitude` varchar(50),
          `longitude` varchar(50),
          `detail` text NOT NULL,
          `logo` varchar(50),
          `merchant_profile_id`  int(11) unsigned NOT NULL,
           PRIMARY KEY (`id`),
          FOREIGN KEY (`merchant_profile_id`) REFERENCES `merchant_profiles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
          ) ENGINE=InnoDB;

    )

  end

  def self.down
    drop_table :companies
  end
end
