class DealLocationDetail < ActiveRecord::Base
  belongs_to :deal



  def self.all_deals
   find(:all)
  end
end
