class CustomerMailer < ActionMailer::Base
  def signup_notification(customer)
    setup_email(customer)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = "http://YOURSITE/activate/#{customer.activation_code}"
  
  end
  
  def activation(customer)
    setup_email(customer)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://YOURSITE/"
  end

  def merchant_registration(merchant_profile,merchant_company )
    merchant_email(merchant_profile)
    @body[:merchant_profile]  = merchant_profile
    @body[:merchant_company] = merchant_company
    content_type "text/html"
  end
  
  protected
  def setup_email(customer)
    @recipients  = "#{customer.email}"
    @from        = "ADMINEMAIL"
    @subject     = "[YOURSITE] "
    @sent_on     = Time.now
    @body[:customer] = customer
  end

  def  merchant_email(customer)
    @recipients  =  'suresh3484@gmail.com'
    @from        = "#{customer.email_address}"
    @subject     = "Merchant Application for keupons"
    @sent_on     = Time.now
    @body[:customer] = customer
  end
end
