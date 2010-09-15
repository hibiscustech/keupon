module AuthenticatedTestHelper
  # Sets the current customer in the session from the customer fixtures.
  def login_as(customer)
    @request.session[:customer_id] = customer ? (customer.is_a?(Customer) ? customer.id : customers(customer).id) : nil
  end

  def authorize_as(customer)
    @request.env["HTTP_AUTHORIZATION"] = customer ? ActionController::HttpAuthentication::Basic.encode_credentials(customers(customer).login, 'monkey') : nil
  end
  
end
