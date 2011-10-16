class FooterController < ApplicationController
  include AuthenticatedSystem
  
  def contact
    
  end

  def about
    
  end
  
  def jobs
    
  end
  
  def press
    
  end
  
  def legal
    
  end
  
  def privacy
    
  end
  
  def customer_faq
    
  end
  
  def merchant_faq
    
  end
  
  def how_keupon_works
    render :partial => "how_keupon_works"
  end
  
end