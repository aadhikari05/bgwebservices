ActionController::Routing::Routes.draw do |map|

#  map.resources :rec_sites

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
  # map.connect 'rec_site/edit/:id', :controller => "albums", :action => "edit"  
  map.connect 'rec_sites/keywords/', :controller => "rec_sites", :action => "keywords"
  map.connect 'rec_sites/keywords/:keyword', :controller => "rec_sites", :action => "keywords"
  map.connect 'rec_sites/show/:keyword', :controller => "rec_sites", :action => "show"
  map.connect 'rec_sites/states/:name', :controller => "rec_sites", :action => "states"
  map.connect 'rec_sites/states', :controller => "rec_sites", :action => "all_states"
  map.connect 'rec_sites/:keyword',      :controller => "rec_sites", :action => "show"
  map.connect 'rec_sites/:keyword/:name',      :controller => "rec_sites", :action => "features"        
  map.connect ':controller/:action/:keyword'
  map.connect ':controller/:action/:keyword.:format'
  
  #PERMITME ROUTES
  map.connect 'permitme', :controller => "permitme", :action => "show"
  map.connect 'permitme/by_zip/:business_type/:zip.:format', :controller => "permitme", :action => "permitme_by_zip"
  map.connect 'permitme/state_only/:business_type/:state.:format', :controller => "permitme", :action => "permitme_by_state_only"
  map.connect 'permitme/state_and_city/:business_type/:state/:feature.:format', :controller => "permitme", :action => "permitme_by_state_and_feature"
end
