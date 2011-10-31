class MerchantMailer < ActionMailer::Base
  def merchant_registration(merchant_profile,merchant_company )
    merchant_email(merchant_profile)
    @subject     = "Merchant Application for Keupons"
    @body[:merchant_profile]  = merchant_profile
    @body[:merchant_company] = merchant_company
    content_type "text/html"
  end
  
  def merchant_authenticated(merchant_profile, merchant, password, company)   
    merchant_email(merchant_profile)
    @subject     = "Merchant Authenticated for Keupons"
    @body[:merchant_profile]  = merchant_profile
    @body[:merchant] = merchant
    @body[:password] = password
    @body[:merchant_company] = company
    content_type "text/html"
  end

  def your_deal_closed(merchant, merchant_profile, file_path, deal, customers, files)
    merchant_email(merchant_profile)
    @subject     = "Deal Closed"
    @body[:merchant_profile]  = merchant_profile
    @body[:merchant] = merchant
    @body[:deal] = deal
    @body[:customers] = customers

    part :content_type => 'multipart/alternative' do |copy|
      copy.part :content_type => 'text/html' do |html|
        html.body = render( :file => "your_deal_closed.html.erb",
          :body => @body )
      end
    end

    attachment :content_type => files[0].content_type, :body => File.read(file_path), :filename => "customers.csv"
#    unless files[0].nil?
#      part :content_type => files[0].content_type do |p|
#        p.attachment :content_type => files[0].content_type,
#        :body => File.open(file_path, 'rb') { |f| f.read },
#        :filename => "customers.csv"
#      end
#    end
  end

  def confirm_deal(merchant_profile,merchant,deal)
    merchant_email(merchant_profile)
    @subject     = "Confirm Deal"
    @body[:merchant_profile]  = merchant_profile
    @body[:merchant] = merchant
    @body[:deal] = deal
    content_type "text/html"

  end

  protected
  def  merchant_email(merchant_profile)
    @recipients  = "#{merchant_profile.email_address}"
    @bcc = "support@keupons.com"
    @from        = "#{Constant.get_admin_email_id}"    
    @sent_on     = Time.zone.now
  end
end
