class Deal < ActiveRecord::Base


  has_many :customer_deals
  has_many :customers, :through => :customer_deals


  belongs_to :merchant
  belongs_to :deal_type
  belongs_to :deal_category
  belongs_to :deal_sub_category
  
  has_one :deal_schedule
  has_one :deal_location_detail

  has_attached_file :deal_photo,
    :styles => {
      :thumb=> "100x100#",
      :small  => "150x150>" }


  DISCOUNTS = {"80 %" => "80",
    "70 %" => "70",
    "60 %" => "60",
    "50 %" => '50'}
end
