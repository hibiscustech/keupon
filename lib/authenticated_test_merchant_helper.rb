module AuthenticatedTestMerchantHelper
  # Sets the current merchant in the session from the merchant fixtures.
  def login_as(merchant)
    @request.session[:merchant_id] = merchant ? (merchant.is_a?(merchant) ? merchant.id : merchants(merchant).id) : nil
  end

  def authorize_as(merchant)
    @request.env["HTTP_AUTHORIZATION"] = merchant ? ActionController::HttpAuthentication::Basic.encode_credentials(merchants(merchant).login, 'monkey') : nil
  end
  
end
