class MerchantProfile < ActiveRecord::Base
    belongs_to :merchant
    has_one :company
end
