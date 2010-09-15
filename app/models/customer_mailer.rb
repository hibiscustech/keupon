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
  
  protected
    def setup_email(customer)
      @recipients  = "#{customer.email}"
      @from        = "ADMINEMAIL"
      @subject     = "[YOURSITE] "
      @sent_on     = Time.now
      @body[:customer] = customer
    end
end
