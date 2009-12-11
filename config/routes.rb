ActionController::Routing::Routes.draw do |map|

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
  #KEYWORD RECOMMENDED SITES
  map.connect 'rec_sites/keywords/:keyword.:format', :controller => "rec_sites", :action => "keywords"
  map.connect 'rec_sites/keywords/', :controller => "rec_sites", :action => "keywords"
  map.connect 'rec_sites/category/:category.:format', :controller => "rec_sites", :action => "category"
  map.connect 'rec_sites/domain/:domain.:format', :controller => "rec_sites", :action => "domain"

  #STATE RECOMMENDED SITES
#  map.connect 'rec_sites/states/:keyword.:format', :controller => "rec_sites", :action => "states"
#  map.connect 'rec_sites/states.:format', :controller => "rec_sites", :action => "all_states"

  #FEATURE RECOMMENDED SITES
#  map.connect 'rec_sites/features/:zip/:keyword.:format',      :controller => "rec_sites", :action => "features"

  #PERMITME ROUTES
  map.connect 'permitme/by_zip/:business_type/:zip.:format', :controller => "permitme", :action => "permitme_by_zip"
  map.connect 'permitme/by_city/:business_type/:feature.:format', :controller => "permitme", :action => "permitme_by_city"
  map.connect 'permitme/by_county/:business_type/:feature.:format', :controller => "permitme", :action => "permitme_by_county"
  map.connect 'permitme/state_only/:business_type/:alpha.:format', :controller => "permitme", :action => "permitme_by_state_only"
  map.connect 'permitme/all_by_state/:alpha.:format', :controller => "permitme", :action => "all_permitme_by_state"
  map.connect 'permitme/state_and_city/:business_type/:alpha/:feature.:format', :controller => "permitme", :action => "permitme_by_state_and_feature"
  map.connect 'permitme/by_business_type/:business_type.:format', :controller => "permitme", :action => "permitme_by_business_type"
  map.connect 'permitme/by_category/:category.:format', :controller => "permitme", :action => "permitme_by_category"

  #GRANT_LOAN ROUTES
  map.connect 'grant_loan/federal.:format', :controller => "grant_loan", :action => "all_federal"
  map.connect 'grant_loan/state_financing_for/:state_alpha.:format', :controller => "grant_loan", :action => "state_financing"
  map.connect 'grant_loan/federal_and_state_financing_for/:state_alpha.:format', :controller => "grant_loan", :action => "federal_and_state_financing"
  map.connect 'grant_loan/all_financing_for/:specialty_type.:format', :controller => "grant_loan", :action => "all_specialty_type_financing"
  map.connect 'grant_loan/all_financing_by_business_type/:business_type.:format', :controller => "grant_loan", :action => "all_business_type_financing"
  map.connect 'grant_loan/:state_alpha/:business_type/:industry/:specialty_type.:format', :controller => "grant_loan", :action => "show_all"
  
  #GEODATA ROUTES
  map.connect 'geodata/all_links_for_city_of/:feature.:format', :controller => "geodata", :action => "all_links_for_city_of"
  map.connect 'geodata/all_links_for_county_of/:feature.:format', :controller => "geodata", :action => "all_links_for_county_of"
  map.connect 'geodata/city_links_for_state_of/:alpha.:format', :controller => "geodata", :action => "city_links_for_state_of"
  map.connect 'geodata/county_links_for_state_of/:alpha.:format', :controller => "geodata", :action => "county_links_for_state_of"
  map.connect 'geodata/city_county_links_for_state_of/:alpha.:format', :controller => "geodata", :action => "city_county_links_for_state_of"

  map.connect 'geodata/primary_links_for_city_of/:feature.:format', :controller => "geodata", :action => "primary_links_for_city_of"
  map.connect 'geodata/primary_links_for_county_of/:feature.:format', :controller => "geodata", :action => "primary_links_for_county_of"
  map.connect 'geodata/primary_city_links_for_state_of/:alpha.:format', :controller => "geodata", :action => "primary_city_links_for_state_of"
  map.connect 'geodata/primary_county_links_for_state_of/:alpha.:format', :controller => "geodata", :action => "primary_county_links_for_state_of"
  map.connect 'geodata/primary_city_county_links_for_state_of/:alpha.:format', :controller => "geodata", :action => "primary_city_county_links_for_state_of"

  map.connect 'geodata/all_data_for_city_of/:feature.:format', :controller => "geodata", :action => "all_data_for_city_of"
  map.connect 'geodata/all_data_for_county_of/:feature.:format', :controller => "geodata", :action => "all_data_for_county_of"
  map.connect 'geodata/city_data_for_state_of/:alpha.:format', :controller => "geodata", :action => "city_data_for_state_of"
  map.connect 'geodata/county_data_for_state_of/:alpha.:format', :controller => "geodata", :action => "county_data_for_state_of"
  map.connect 'geodata/city_county_data_for_state_of/:alpha.:format', :controller => "geodata", :action => "city_county_data_for_state_of"

#  map.connect 'geodata/by_zip/:zip.:format', :controller => "geodata", :action => "geodata_by_zip"
#  map.connect 'geodata/state_and_city/:alpha/:feature.:format', :controller => "geodata", :action => "geodata_by_state_and_feature"
#  map.connect 'geodata/major_city/:feature.:format', :controller => "geodata", :action => "geodata_by_major_city"

end
