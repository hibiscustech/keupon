module CustomersHelper
  
  #
  # Use this to wrap view elements that the user can't access.
  # !! Note: this is an *interface*, not *security* feature !!
  # You need to do all access control at the controller level.
  #
  # Example:
  # <%= if_authorized?(:index,   User)  do link_to('List all users', users_path) end %> |
  # <%= if_authorized?(:edit,    @user) do link_to('Edit this user', edit_user_path) end %> |
  # <%= if_authorized?(:destroy, @user) do link_to 'Destroy', @user, :confirm => 'Are you sure?', :method => :delete end %> 
  #
  #
  def if_authorized?(action, resource, &block)
    if authorized?(action, resource)
      yield action, resource
    end
  end

  #
  # Link to user's page ('customers/1')
  #
  # By default, their login is used as link text and link title (tooltip)
  #
  # Takes options
  # * :content_text => 'Content text in place of customer.login', escaped with
  #   the standard h() function.
  # * :content_method => :customer_instance_method_to_call_for_content_text
  # * :title_method => :customer_instance_method_to_call_for_title_attribute
  # * as well as link_to()'s standard options
  #
  # Examples:
  #   link_to_customer @customer
  #   # => <a href="/customers/3" title="barmy">barmy</a>
  #
  #   # if you've added a .name attribute:
  #  content_tag :span, :class => :vcard do
  #    (link_to_customer customer, :class => 'fn n', :title_method => :login, :content_method => :name) +
  #          ': ' + (content_tag :span, customer.email, :class => 'email')
  #   end
  #   # => <span class="vcard"><a href="/customers/3" title="barmy" class="fn n">Cyril Fotheringay-Phipps</a>: <span class="email">barmy@blandings.com</span></span>
  #
  #   link_to_customer @customer, :content_text => 'Your user page'
  #   # => <a href="/customers/3" title="barmy" class="nickname">Your user page</a>
  #
  def link_to_customer(customer, options={})
    raise "Invalid customer" unless customer
    options.reverse_merge! :content_method => :login, :title_method => :login, :class => :nickname
    content_text      = options.delete(:content_text)
    content_text    ||= customer.send(options.delete(:content_method))
    options[:title] ||= customer.send(options.delete(:title_method))
    link_to h(content_text), customer_path(customer), options
  end

  #
  # Link to login page using remote ip address as link content
  #
  # The :title (and thus, tooltip) is set to the IP address 
  #
  # Examples:
  #   link_to_login_with_IP
  #   # => <a href="/login" title="169.69.69.69">169.69.69.69</a>
  #
  #   link_to_login_with_IP :content_text => 'not signed in'
  #   # => <a href="/login" title="169.69.69.69">not signed in</a>
  #
  def link_to_login_with_IP content_text=nil, options={}
    ip_addr           = request.remote_ip
    content_text    ||= ip_addr
    options.reverse_merge! :title => ip_addr
    if tag = options.delete(:tag)
      content_tag tag, h(content_text), options
    else
      link_to h(content_text), login_path, options
    end
  end

  #
  # Link to the current user's page (using link_to_customer) or to the login page
  # (using link_to_login_with_IP).
  #
  def link_to_current_customer(options={})
    if current_customer
      link_to_customer current_customer, options
    else
      content_text = options.delete(:content_text) || 'not signed in'
      # kill ignored options from link_to_customer
      [:content_method, :title_method].each{|opt| options.delete(opt)} 
      link_to_login_with_IP content_text, options
    end
  end

end
