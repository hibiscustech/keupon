class Customer < ActiveRecord::Base
    has_one :customer_profile, :dependent => :destroy
    has_one :customer_favourite_deal

    has_many :customer_deals
    has_many :deals, :through => :customer_deals

    has_many :customer_credit_card

end
