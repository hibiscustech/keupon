class CreateAdminUsers < ActiveRecord::Migration
  def self.up
    execute %Q(

                CREATE TABLE `admin_users` (
                `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                `time_created` int(11) unsigned NOT NULL,
                `deleted` enum('Yes','No') NOT NULL DEFAULT 'No',
                `login` varchar(50) DEFAULT NULL,
                `email` varchar(50) DEFAULT NULL,
                `salt` varchar(50) DEFAULT NULL,
                `crypted_password` varchar(255) DEFAULT NULL,
                `activation_code` varchar(255) DEFAULT NULL,
                `activated_at` datetime DEFAULT NULL,
                 PRIMARY KEY (`id`)
                ) ENGINE=InnoDB;


    )


  end

  def self.down
    drop_table :admin_users
  end
end
