require 'digest/sha1'

class Customer < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

#  validates_presence_of     :login
#  validates_length_of       :login,    :within => 3..40
#  validates_uniqueness_of   :login
#  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message



  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email,:message=>"Id - is already in use, please use another email"
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  before_create :make_activation_code 

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation

  has_one :customer_profile, :dependent => :destroy
  has_one :customer_favourite_deal

  has_many :customer_deals
  has_many :deals, :through => :customer_deals
  has_many :customer_credit_cards
  has_many :merchants_customers
  has_many :merchants, :through => :merchants_customers
  has_many :customer_demand_deals

  has_attached_file :customer_photo,
    :styles => {
      :thumb=> "100x100#",
      :medium => "70x50#",
      :small  => "95x80#" }

  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  def self.all_customers
    Customer.find(:all)
  end

  def self.verify_customer(customer_pin)
    query = %Q{ select c.id
                from customers c
                join customer_profiles cp on cp.customer_id = c.id
                where cp.customer_pin = '#{customer_pin}' }
    find_by_sql(query)[0]
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def self.customers_summary(sort)
    query = %Q{ select c.id, c.time_created, concat(cp.first_name,' ',cp.last_name) as name, cp.customer_pin, cp.dob, cp.contact_number as phone, c.email, cp.income, concat(cp.address1,' ',cp.address2, ' ', cp.country,' - ',cp.zipcode) as location, c.kupoints, sum(case when cd.quantity is null then 0 else cd.quantity end) total_bought, sum(case when cf.signed_up = '1' then 1 else 0 end) introduced, sum(case when cdt.transaction_type = 'Postauth' then cdt.amount else 0 end) spendings
                from customers c
                join customer_profiles cp on c.id = cp.customer_id
                left outer join customer_deals cd on cd.customer_id = c.id
                left outer join customer_friends cf on cf.customer_id = c.id
                left outer join customer_deal_transactions cdt on cdt.customer_deal_id = cd.id
                group by c.id order by #{sort}}
    find_by_sql(query)
  end

  def self.verifying_already_member?(email)
    query = %Q{ select * from customers where login = '#{email}'}
    results = find_by_sql(query)
    return (results.blank?)? false : true
  end

  def self.birthdate_to_age(bDate) 
    age = Date.today.year - bDate.year
    if Date.today.month < bDate.month || (Date.today.month == bDate.month && bDate.day >= Date.today.day)
      age = age - 1
    end
    age.to_s
  end

  protected
    
    def make_activation_code
        self.activation_code = self.class.make_token
    end


end
