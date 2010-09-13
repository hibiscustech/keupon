class CreateMerchantProfiles < ActiveRecord::Migration
  def self.up

     execute %Q(
    
                CREATE TABLE `merchant_profiles` (
                `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                `first_name` varchar(30) NOT NULL,
                `last_name` varchar(30) DEFAULT NULL,
                `gender` enum('m','f') NOT NULL DEFAULT 'm',
                `address1` varchar(50) NOT NULL,
                `address2` varchar(50) DEFAULT NULL,
                `city` varchar(30) NOT NULL,
                `state` varchar(30) NOT NULL,
                `zipcode` varchar(10) NOT NULL,
                `contact_number` varchar(15) NOT NULL,
                `email_address` varchar(50) NOT NULL,
                `merchant_id` int(11) unsigned NOT NULL,
                `dob` int(11) unsigned DEFAULT NULL,
                PRIMARY KEY (`id`),
                KEY `merchant_id` (`merchant_id`),
                CONSTRAINT `merchant_profiles_ibfk_1` FOREIGN KEY (`merchant_id`) REFERENCES `merchants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
              ) ENGINE=InnoDB;
     )


  end

  def self.down
    drop_table :merchant_profiles
  end
end
