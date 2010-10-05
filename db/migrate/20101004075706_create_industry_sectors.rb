class CreateIndustrySectors < ActiveRecord::Migration
  def self.up
    execute %Q{ CREATE TABLE `industry_sectors` (
                `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                `name` varchar(100) NOT NULL,
                PRIMARY KEY (`id`)
                ) ENGINE=InnoDB
              }

    execute %Q{ insert into industry_sectors(name) values
                ('Accounting/Audit/Tax Services'),
                ('Advertising/Public relations/Marketing Services'),
                ('Aerospace/Aviation'),
                ('Agriculture/Forestry/Fishing'),
                ('Architecture/Building/Construction'),
                ('Arts'),
                ('Athletics/Sports'),
                ('Charity/Social Services/Non-Profit Organisation'),
                ('Chemical/Plastic/Paper/Petrochemical'),
                ('Civil Services (Government, Armed Forces)'),
                ('Clothing/Garment/Textile'),
                ('Education'),
                ('Electronics/Electrical Equipment'),
                ('Energy/Power/Water/Oil and Gas/Waste Management'),
                ('Engineering - Building, Civil, Construction / Quantity Survey'),
                ('Engineering - Electrical/Electronic/Mechanical'),
                ('Engineering - Others'),
                ('Entertainment/Recreation'),
                ('Environmental Science'),
                ('Banking and Financial Services'),
                ('Food and Beverage / Catering'),
                ('Freight Forwarding/Delivery/Shipping'),
                ('General Management/Business Analysis'),
                ('Health and Beauty Care'),
                ('Hospitality/Catering'),
                ('Human Resources Management/Consultancy'),
                ('Industrial Machinery/Automation Equipment'),
                ('Information Technology'),
                ('Insurance/Pension Funding'),
                ('Interior Design/Graphic Design'),
                ('Jewellery/Gems/Watches'),
                ('Legal Services'),
                ('Life Sciences'),
                ('Logistics'),
                ('Management Consultancy/Service'),
                ('Manufacturing'),
                ('Mass Transportation'),
                ('Media/Publishing/Printing'),
                ('Medical/Pharmaceutical'),
                ('Mixed Industry Group'),
                ('Motor Vehicles'),
                ('Performance/Musical/Artistic'),
                ('Petroleum'),
                ('Property Development'),
                ('Property Management/Consultancy'),
                ('Public Utilities'),
                ('Research/Survey'),
                ('Security Escort'),
                ('Security/Fire/Electronic Access Controls'),
                ('Telecommunication'),
                ('Tourism/Travel Agency'),
                ('Toys'),
                ('Trading and Distribution'),
                ('Wholesale / Retail'),
                ('Others');
              }
    execute %Q{ ALTER TABLE `customer_profiles` ADD COLUMN `industry_sector_id` INT(11) UNSIGNED,
                ADD INDEX `industry_sector_id` USING BTREE(`industry_sector_id`),
                ADD CONSTRAINT `customer_profiles_ibfk_2` FOREIGN KEY `customer_profiles_ibfk_2` (`industry_sector_id`) REFERENCES `industry_sectors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
              }
  end

  def self.down
    drop_table :industry_sectors
  end
end
