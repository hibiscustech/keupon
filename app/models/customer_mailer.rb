class CustomerMailer < ActionMailer::Base
  def signup_notification(customer)
    setup_email(customer)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://dev.keupons.com/activate/#{customer.activation_code}"
  end
  
  def activation(customer)
    setup_email(customer)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://dev.keupons.com/"
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
    @subject     = "http://dev.keupons.com/"
    @sent_on     = Time.now
    @body[:customer] = customer
  end

  def  merchant_email(merchant_profile)
    @recipients  = "#{merchant_profile.email_address}"
    @from        = "#{Constant.get_admin_email_id}"
    @subject     = "Merchant Application for Keupons"
    @sent_on     = Time.now
  end
end
