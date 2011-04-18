class CustomerFriend < ActiveRecord::Base
  belongs_to :customer

  def self.who_invited_me(customer_email)
    query = %Q{select * from customer_friends where friend_email = '#{customer_email}'}
    find_by_sql(query)
  end
end
