ActionController::Routing::Routes.draw do |map|
  map.resources :marketing_messages

 
  map.root :controller => "customers", :action => "deal_of_the_day"

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.redeem_deals '/redeem_deals', :controller => 'merchant', :action => 'redeem_deals'
  map.signup '/merchant_signup', :controller => 'merchant', :action => 'new'
  map.merchant_register '/merchant_register', :controller => 'merchant', :action => 'create'
  map.index '/index', :controller => 'merchant', :action => 'index'
  map.location_deals '/location_deals', :controller => 'merchant', :action => 'location_deals'
  map.keupoint_deals '/keupoint_deals', :controller => 'merchant', :action => 'keupoint_deals'
  map.gift_deals '/gift_deals', :controller => 'merchant', :action => 'gift_deals'
  map.deals_of_mine '/deals_of_mine' , :controller => 'merchant', :action => 'deals_of_mine'
  map.deals_on_demand 'deals_on_demand',:controller => 'merchant' ,:action => 'deals_on_demand'
  map.transaction_details '/transaction_details' , :controller => 'customers', :action =>  'transaction_details'
  map.demand_deal_transaction_details '/demand_deal_transaction_details' , :controller => 'customers', :action =>  'demand_deal_transaction_details'
  map.register '/register', :controller => 'customers', :action => 'create'
  map.signup '/signup', :controller => 'customers', :action => 'new'
  map.connect '/signup/:id', :controller => 'customers', :action => 'new'
  map.signup '/admin_create', :controller => 'sessions', :action => 'admin_create'
  map.forgot_password '/forgot_password', :controller => 'customers', :action => 'forgot_password'
  map.change_password '/change_password', :controller => 'customers', :action => 'change_password'
   
  map.activate '/activate/:activation_code', :controller => 'customers', :action => 'activate', :activation_code => nil
  map.get_location_deal '/get_location_deal' , :controller => 'customers', :action => 'get_location_deal'
  map.update '/update', :controller => 'customers', :action => 'settings'
  map.deal_of_the_day '/deal_of_the_day', :controller => 'customers', :action => 'deal_of_the_day'
  map.deal_details '/deal_details', :controller => 'customers', :action => 'deal_details'
  map.deal_details '/deal_details/:id/:comments/:forum_id', :controller => 'customers', :action => 'deal_details'
  map.deal_of_the_day '/keupoint_deal', :controller => 'customers', :action => 'keupoint_deal'
  map.profile_update 'profile_update' , :controller => 'customers', :action => 'profile_update'
  map.my_profile 'my_profile' , :controller => 'customers', :action => 'my_profile'
  map.recent_deals 'recent_deals' , :controller => 'customers', :action => 'recent_deals'
  map.offered_deals 'offered_deals' , :controller => 'customers', :action => 'offered_deals'
  map.want_a_deal 'want_a_deal' , :controller => 'customers', :action => 'want_a_deal'
  map.my_keupons '/my_keupons',:controller => 'customers' ,:action => 'my_keupons'
  #map.location_deals '/customers/location_deals', :controller => 'customers', :action => 'location_deals'
  map.open_deals '/open_deals', :controller => 'customers', :action => 'open_deals'
  map.merchant_analytics '/merchant_analytics', :controller => 'merchant_analytics', :action => 'index'
  map.change_password_updates '/change_password_update', :controller => 'sessions', :action => 'change_password_update'
  map.admin_analytics '/admin_analytics', :controller => 'admin_analytics', :action => 'index'
  map.connect '/get_sub_category',:controller=>'merchant',:action=>'company_sub_categories'
  map.connect '/sub_category',:controller=>'merchant',:action=>'company_none_subcategories'  
  map.connect '/profile',:controller=>'merchant',:action=>'my_profile'  
  map.connect '/merchants/profile_update',:controller=>'merchant',:action=>'profile_update'  
  map.connect '/company',:controller=>'merchant',:action=>'my_company'  
  map.connect '/password_change',:controller=>'merchant',:action=>'password_change'  
  map.connect '/merchants/contact_details/:id',:controller=>'merchant',:action=>'contact_details'
  map.connect '/merchants/merchant_profile_update' ,:controller => 'merchant', :action => 'merchant_profile_update'
  
  map.connect '/merchants/my_company',:controller=>'merchant',:action=>'my_company'  
  map.connect '/invite_friends',:controller=>'customers',:action=>'invite_friends'
  map.connect '/add_a_friend',:controller=>'customers',:action=>'add_a_friend'
  map.connect '/deals_on_demand_new_or_confirmed/:user_id',:controller=>'api',:action=>'deals_on_demand_new_or_confirmed'
  map.connect '/deals_available',:controller=>'api',:action=>'deals_available'
  map.connect '/my_keupons_api/:user_id',:controller=>'api',:action=>'my_keupons'
  map.connect '/offered_deals_api/:deal',:controller=>'api',:action=>'offered_deals_api'
  map.connect '/deal_details_api/:id',:controller=>'api',:action=>'deal_details_api'
  map.connect '/under_construction',:controller=>'customers',:action=>'under_construction'
  map.connect '/contact',:controller=>'footer',:action=>'contact'
  map.connect '/about',:controller=>'footer',:action=>'about'
  map.connect '/jobs',:controller=>'footer',:action=>'jobs'
  map.connect '/press',:controller=>'footer',:action=>'press'
  map.connect '/legal',:controller=>'footer',:action=>'legal'
  map.connect '/privacy',:controller=>'footer',:action=>'privacy'
  map.connect '/customer_faqs',:controller=>'footer',:action=>'customer_faq'
  map.connect '/merchant_faqs',:controller=>'footer',:action=>'merchant_faq'
  map.connect '/myprofile/:id',:controller=>'api',:action=>'my_profile'
  map.connect '/want_a_deal_api/:user_id',:controller=>'api',:action=>'want_a_deal_api'
  map.connect 'update_demand_deal_api/:user_id/:deal_id',:controller=>'api',:action=>'update_demand_deal_api'
  map.resources :customers  
  map.resource :merchant
  map.resource :session



  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
