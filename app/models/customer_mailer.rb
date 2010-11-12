class CustomerMailer < ActionMailer::Base
  def signup_notification(customer)
    setup_email(customer)
    @subject    += 'Please activate your new account'
    @body[:url]  = "/activate/#{customer.activation_code}"
    @body[:profile] = customer.customer_profile
    content_type "text/html"
  end
  
  def activation(customer)
    setup_email(customer)
    @subject    += 'Your account has been activated!'
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
