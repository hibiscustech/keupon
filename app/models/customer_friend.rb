class CustomerFriend < ActiveRecord::Base
  belongs_to :customer

  def self.who_invited_me(customer_email)
    query = %Q{select * from customer_friends where friend_email = '#{customer_email}'}
    find_by_sql(query)
  end

  def self.signed_up_invitees(customer)
    query = %Q{ select count(*) as signedup from customer_friends where customer_id = #{customer} and signed_up = '1'}
    return find_by_sql(query)[0].signedup
  end

  def self.my_signed_up_invitees(customer)
    query = %Q{ select * from customer_friends where customer_id = '#{customer}' and signed_up = '1'}
    return find_by_sql(query)
  end
end
