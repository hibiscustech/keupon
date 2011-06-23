class AdminMailer < ActionMailer::Base

  def opened_deals(deals)
    admin_email("Notification - Deals Opened Today")
    @body[:deals]  = deals
    content_type "text/html"
  end

  def merchant_registration_notification(merchant_profile, merchant_company )
    admin_email("Notification - Merchant Application for Keupons")
    @body[:merchant_profile]  = merchant_profile
    @body[:merchant_company] = merchant_company
    content_type "text/html"
  end

  def merchant_created_preferred_deal(deal, merchant_profile, merchant_company)
    admin_email("Notification - Merchant Created a Highly Preferred Deal")
    @body[:merchant_profile]  = merchant_profile
    @body[:merchant_company] = merchant_company
    @body[:deal] = deal
    content_type "text/html"
  end

  def merchant_deal_closed(merchant, merchant_profile, file_path, deal, customers, files)
    admin_email("Notification - Deal Closed")
    @body[:merchant_profile]  = merchant_profile
    @body[:merchant] = merchant
    @body[:deal] = deal
    @body[:customers] = customers

    part :content_type => 'multipart/alternative' do |copy|
      copy.part :content_type => 'text/html' do |html|
        html.body = render( :file => "merchant_deal_closed.erb",
          :body => @body )
      end
    end

    attachment :content_type => files[0].content_type, :body => File.read(file_path), :filename => "customers.csv"
  end

  protected
  def admin_email(subject)
    @recipients  = "#{Constant.get_admin_email_id}"
    @from        = "#{Constant.get_admin_email_id}"
    @subject     = subject
    @sent_on     = Time.zone.now
  end

end