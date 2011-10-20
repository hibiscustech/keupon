class CustomerObserver < ActiveRecord::Observer
#  def after_create(customer)
#    CustomerMailer.deliver_signup_notification(customer)
#  end

#  def after_save(customer)
#  
#    CustomerMailer.deliver_activation(customer) if customer.recently_activated?
#  
#  end
end
