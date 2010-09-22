# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100922064043) do

  create_table "companies", :force => true do |t|
    t.string  "name",                :limit => 50, :null => false
    t.string  "website",             :limit => 50, :null => false
    t.string  "address1",            :limit => 50, :null => false
    t.string  "address2",            :limit => 50
    t.string  "city",                :limit => 30, :null => false
    t.string  "state",               :limit => 30, :null => false
    t.string  "zipcode",             :limit => 10, :null => false
    t.string  "latitude",            :limit => 50
    t.string  "longitude",           :limit => 50
    t.text    "detail"
    t.string  "logo",                :limit => 50
    t.integer "merchant_profile_id",               :null => false
  end

  add_index "companies", ["merchant_profile_id"], :name => "merchant_profile_id"

  create_table "constants", :force => true do |t|
    t.string "name",  :limit => 30, :null => false
    t.string "value",               :null => false
  end

  create_table "customer_credit_cards", :force => true do |t|
    t.integer "time_created",                                       :null => false
    t.integer "time_modified",                                      :null => false
    t.string  "deleted",            :limit => 0,  :default => "No", :null => false
    t.integer "customer_id",                                        :null => false
    t.string  "credit_card_number", :limit => 50,                   :null => false
    t.integer "expiration_month",                                   :null => false
    t.integer "expiration_year",                                    :null => false
    t.string  "card_type",          :limit => 25,                   :null => false
    t.string  "address1",           :limit => 50
    t.string  "address2",           :limit => 50
    t.string  "city",               :limit => 50
    t.string  "state",              :limit => 50
    t.string  "zipcode",            :limit => 25
    t.string  "phone",              :limit => 25
    t.string  "country",            :limit => 50
    t.string  "first_name",         :limit => 50
    t.string  "last_name",          :limit => 50
    t.string  "cvv2",               :limit => 25
  end

  add_index "customer_credit_cards", ["customer_id"], :name => "customer_id"

  create_table "customer_deal_transactions", :force => true do |t|
    t.integer "time_created",                                                  :null => false
    t.string  "transaction_type",        :limit => 0,                          :null => false
    t.integer "customer_credit_card_id",                                       :null => false
    t.float   "amount",                                                        :null => false
    t.integer "customer_deal_id",                                              :null => false
    t.text    "error_message"
    t.text    "message"
    t.string  "status",                  :limit => 0
    t.string  "transaction_key"
    t.string  "payment_type",            :limit => 0, :default => "Reference", :null => false
  end

  add_index "customer_deal_transactions", ["customer_credit_card_id"], :name => "customer_credit_card_id"
  add_index "customer_deal_transactions", ["customer_deal_id"], :name => "customer_deal_id"

  create_table "customer_deals", :force => true do |t|
    t.integer "customer_id",                                  :null => false
    t.integer "deal_id",                                      :null => false
    t.integer "quantity",                                     :null => false
    t.string  "status",      :limit => 0,  :default => "new", :null => false
    t.string  "deal_code",   :limit => 25,                    :null => false
  end

  add_index "customer_deals", ["customer_id"], :name => "customer_id"
  add_index "customer_deals", ["deal_id"], :name => "deal_id"

  create_table "customer_favourite_deals", :force => true do |t|
    t.integer "customer_id",          :null => false
    t.integer "deal_category_id",     :null => false
    t.integer "deal_sub_category_id", :null => false
  end

  add_index "customer_favourite_deals", ["customer_id"], :name => "customer_id"
  add_index "customer_favourite_deals", ["deal_category_id"], :name => "deal_category_id"
  add_index "customer_favourite_deals", ["deal_category_id"], :name => "deal_sub_category_id"
  add_index "customer_favourite_deals", ["deal_sub_category_id"], :name => "cfd _ibfk_2"

  create_table "customer_kupoints", :force => true do |t|
    t.integer "customer_deal_id",                                     :null => false
    t.integer "kupoints",                                             :null => false
    t.integer "time_created",                                         :null => false
    t.string  "status",           :limit => 0, :default => "pending", :null => false
  end

  add_index "customer_kupoints", ["customer_deal_id"], :name => "customer_deal_id"

  create_table "customer_profiles", :force => true do |t|
    t.string  "first_name",     :limit => 30,                  :null => false
    t.string  "last_name",      :limit => 30
    t.string  "gender",         :limit => 0,  :default => "m", :null => false
    t.string  "address1",       :limit => 50,                  :null => false
    t.string  "address2",       :limit => 50
    t.string  "city",           :limit => 30,                  :null => false
    t.string  "state",          :limit => 30,                  :null => false
    t.string  "zipcode",        :limit => 10,                  :null => false
    t.string  "contact_number", :limit => 15,                  :null => false
    t.string  "email_address",  :limit => 50,                  :null => false
    t.integer "customer_id",                                   :null => false
    t.integer "dob"
    t.string  "country"
  end

  add_index "customer_profiles", ["customer_id"], :name => "customer_id"

  create_table "customers", :force => true do |t|
    t.integer  "time_created",                                     :null => false
    t.string   "deleted",          :limit => 0,  :default => "No", :null => false
    t.string   "login",            :limit => 50
    t.string   "email",            :limit => 50
    t.string   "salt",             :limit => 50
    t.string   "crypted_password"
    t.integer  "kupoints",                                         :null => false
    t.string   "activation_code"
    t.datetime "activated_at"
  end

  create_table "deal_categories", :force => true do |t|
    t.string "name", :limit => 50, :null => false
  end

  create_table "deal_location_details", :force => true do |t|
    t.integer "deal_id",                 :null => false
    t.string  "address1",  :limit => 50
    t.string  "address2",  :limit => 50
    t.string  "city",      :limit => 30
    t.string  "state",     :limit => 30
    t.string  "zipcode",   :limit => 10
    t.string  "latitude",  :limit => 50
    t.string  "longitude", :limit => 50
  end

  add_index "deal_location_details", ["deal_id"], :name => "deal_id"

  create_table "deal_schedules", :force => true do |t|
    t.integer "deal_id",    :null => false
    t.integer "start_time", :null => false
    t.integer "end_time",   :null => false
  end

  add_index "deal_schedules", ["deal_id"], :name => "deal_id"

  create_table "deal_sub_categories", :force => true do |t|
    t.string  "name",             :limit => 50, :null => false
    t.integer "deal_category_id",               :null => false
  end

  add_index "deal_sub_categories", ["deal_category_id"], :name => "deal_category_id"

  create_table "deal_types", :force => true do |t|
    t.string "name", :limit => 50, :null => false
  end

  create_table "deals", :force => true do |t|
    t.text    "name",                                                    :null => false
    t.float   "buy",                                                     :null => false
    t.float   "value",                                                   :null => false
    t.float   "discount",                                                :null => false
    t.float   "save_amount",                                             :null => false
    t.integer "number",                                                  :null => false
    t.integer "deal_photo",                                              :null => false
    t.string  "rules"
    t.string  "highlights"
    t.string  "status",                  :limit => 0, :default => "new", :null => false
    t.integer "expiry_date",                                             :null => false
    t.integer "deal_type_id",                                            :null => false
    t.integer "merchant_id",                                             :null => false
    t.integer "deal_category_id",                                        :null => false
    t.integer "deal_sub_category_id",                                    :null => false
    t.string  "deal_photo_file_name"
    t.string  "deal_photo_content_type"
    t.integer "deal_photo_file_size"
  end

  add_index "deals", ["deal_category_id"], :name => "deal_category_id"
  add_index "deals", ["deal_sub_category_id"], :name => "deal_sub_category_id"
  add_index "deals", ["deal_type_id"], :name => "deal_type_id"
  add_index "deals", ["merchant_id"], :name => "merchant_id"

  create_table "merchant_profiles", :force => true do |t|
    t.string  "first_name",     :limit => 30,                    :null => false
    t.string  "last_name",      :limit => 30
    t.string  "gender",         :limit => 0,  :default => "m"
    t.string  "address1",       :limit => 50
    t.string  "address2",       :limit => 50
    t.string  "city",           :limit => 30
    t.string  "state",          :limit => 30
    t.string  "zipcode",        :limit => 10
    t.string  "contact_number", :limit => 15,                    :null => false
    t.string  "email_address",  :limit => 50,                    :null => false
    t.integer "merchant_id"
    t.integer "dob"
    t.string  "country"
    t.string  "status",         :limit => 0,  :default => "new", :null => false
  end

  add_index "merchant_profiles", ["merchant_id"], :name => "merchant_id"

  create_table "merchants", :force => true do |t|
    t.integer  "time_created",                                     :null => false
    t.string   "deleted",          :limit => 0,  :default => "No", :null => false
    t.string   "login",            :limit => 50
    t.string   "email",            :limit => 50
    t.string   "salt",             :limit => 50
    t.string   "crypted_password"
    t.string   "activation_code"
    t.datetime "activated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

end
