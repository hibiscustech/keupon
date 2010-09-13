class Merchant < ActiveRecord::Base
   has_one :merchant_profile, :dependent => :destroy
   
end
