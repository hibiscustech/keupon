module MerchantHelper

  def categories
     @categories = DealCategory.find(:all)
  end
  
end

