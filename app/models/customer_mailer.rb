class CustomerMailer < ActionMailer::Base
  def signup_notification(customer)
    setup_email(customer)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://dev.keupons.com/activate/#{customer.activation_code}"
    content_type "text/html"
  end
  
  def activation(customer)
    setup_email(customer)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://dev.keupons.com/"
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
