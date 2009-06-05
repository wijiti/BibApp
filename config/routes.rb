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

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  #####
  # Work routes
  ##### 
  # Add Auto-Complete Routes for Web-Based Work entry
  map.resources :works,
                :collection => {:auto_complete_for_author_string => :get,
                        :auto_complete_for_editor_string => :get,
                        :auto_complete_for_keyword_name => :get,
                        :auto_complete_for_publication_name => :get,
                        :auto_complete_for_publisher_name => :get,
                        :auto_complete_for_tag_name => :get,
                        :review_batch => :get,
                        :destroy_multiple => :delete},
                :member => {:merge_duplicates => :get} do |c|
    # Make URLs like /work/2/attachments/4 for Work Content Files
    c.resources :attachments
  end

  #####
  # Person routes
  #####
  map.resources :people do |p|
    # Make URLs like /people/1/attachments/2 for Person Images
    p.resources :attachments
    # Make URLs like /people/1/works (and allow adding Works to People)
    p.resources :works
    # Make URLs like /people/1/groups
    p.resources :groups
    # Make URLs like /people/1/pen_names
    p.resources :pen_names
    # Make URLs like /people/1/memberships
    p.resources :memberships
    # Make URLs like /people/1/roles/3 for user roles on a specific Person
    p.resources :roles, :collection => {:new_admin => :get, :new_editor => :get}
  end
 
  #####
  # Group routes
  ##### 
  # Add Auto-Complete routes for adding new groups
  map.resources :groups, 
                :collection => {:auto_complete_for_group_name => :get} do |g|
    # Make URLs like /group/1/works/4
    g.resources :works
    # Make URLs like /group/1/roles/3 for roles on a specific Group
    g.resources :roles, :collection => {:new_admin => :get, :new_editor => :get}
  end

  #####
  # Membership routes
  #####
  # Add Auto-Complete routes
  map.resources :memberships, 
                :collection => {:auto_complete_for_group_name => :get,
                                :create_multiple => :put
                                }
  
  #####
  # Contributorship routes
  #####
  map.resources :contributorships,
                :collection => { :admin => :get,
                                 :archivable => :get,
                                 :verify_multiple => :put,
                                 :unverify_multiple => :put,
                                 :deny_multiple => :put },
                :member => { :verify => :put, :deny => :put }
    
  #####
  # Publisher routes
  #####   
  map.resources :publishers,    :collection => { :authorities => :get, :update_multiple => :put }
  
  
  #####
  # Publication routes
  #####
  map.resources :publications,  :collection => { :authorities => :get, :update_multiple => :put }
  
  ####
  # User routes
  ####
  # Make URLs like /user/1/password/edit for Users managing their passwords
  map.resources :users, :has_one => [:password]
  

  ####
  # Search route
  ####
  map.search 'search', :controller => 'search', :action => 'index'
  map.advanced_search 'search/advanced', :controller => 'search', :action => 'advanced'
  
  ####
  # Cart routes
  ####
  map.cart '/cart',
    :controller => 'sessions',
    :action => 'cart'
  map.delete_cart '/sessions/delete_cart',
    :controller => 'sessions',
    :action => 'delete_cart'
  map.add_many_to_cart '/sessions/add_many_to_cart',
    :controller => 'sessions',
    :action => 'add_many_to_cart'
  
  ####
  # Authentication routes
  ####
  # Make easier routes for authentication (via restful_authentication)
  map.signup '/signup',
    :controller => 'users',
    :action => 'new'
  map.login '/login',
    :controller => 'sessions',
    :action => 'new'
  map.logout '/logout',
    :controller => 'sessions',
    :action => 'destroy'
  map.activate '/activate/:activation_code',
    :controller => 'users',
    :action => 'activate'
  
  ####
  # DEFAULT ROUTES 
  ####
  # Install the default routes as the lowest priority.
  map.resources :name_strings,
    :memberships,
    :pen_names,
    :keywords,
    :keywordings,
    :sessions,
    :passwords,
    :attachments

  # Default homepage to works index action
  map.connect "/",
    :controller => 'works',
    :action => 'index'
    
  map.connect "citations",
    :controller => 'works',
    :action => 'index'
    
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
