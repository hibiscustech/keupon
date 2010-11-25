class CustomerMailer < ActionMailer::Base
  def signup_notification(customer)
    setup_email(customer)
    @subject    = 'Please activate your new account'
    @body[:url]  = "/activate/#{customer.activation_code}"
    content_type "text/html"
  end

  def deal_purchase_notification(customer, profile, customer_deal, deal)
    setup_email(customer)
    @subject    = 'You have purchased a Deal from Keupons'
    @body[:profile] = profile
    @body[:customer_deal] = customer_deal
    @body[:deal] = deal
    content_type "text/html"
  end
  
  def activation(customer)
    setup_email(customer)
    @subject    = 'Your account has been activated!'
    @body[:profile] = customer.customer_profile
    content_type "text/html"
  end 
  
  protected
  def setup_email(customer)
    @recipients  = "#{customer.email}"
    @from        = "#{Constant.get_admin_email_id}"
    @sent_on     = Time.now
    @body[:customer] = customer
  end 
end
