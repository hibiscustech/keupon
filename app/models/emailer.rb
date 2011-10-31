class Emailer < ActionMailer::Base
  
  def contact(recipient, subject, message, sent_at = Time.now)
      @subject = subject
      @recipients = recipient
      @from = 'akshay@keupons.com'
      @sent_on = sent_at
	  @body["title"] = 'This is testing title'
  	  @body["email"] = recipient
   	  @body["message"] = message
      @headers = {}
   end
end

