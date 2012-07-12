Cfeup::Application.routes.draw do
  resources :evaluations

  resources :ad_tags do
    collection do
      get 'all'
    end
  end

  resources :reports

  resources :comments do
    member do 
      post 'report'
    end
  end
  
  resources :ads do
    member do
      get 'mark_fav'
      get 'unmark_fav'
      post 'rate'
      post 'close'
      post 'close_permanently'
      put 'rate'
      post 'edit_title'
      post 'edit_description'
      post 'edit_tags'
      get 'gallery_manager'
      post 'add_resource'
      post 'remove_resource'
      get 'show_rate_owner'
      post 'rate_owner'
    end    
    collection do
      get 'dashboard'
      get 'update_search'
      get 'update_section'
    end
  end
  
  match "ads/:id" => "ads#show", :via => :post
  
  resources :resources

  resources :sections

  resources :block_logs

  resources :users do
    collection do
      post 'authenticate'
      get 'auto_complete'
      get 'ads'
      get 'favorites'
    end
  end
  
  resources :ratings
    
  match "login" => "users#login"
  match "logout" => "users#logout"
  match "admin" => "admin#index"
  
  match "admin/comments" => "admin#reported_comments"
  match "admin/users" => "admin#users"
  match "admin/update_search" => "admin#update_search"
  match "admin/promote" => "admin#promote_user"
  match "admin/demote" => "admin#demote_user"
  match "admin/block" => "admin#block_user"
  match "admin/unblock" => "admin#unblock_user"
  
  root :to => "ads#dashboard"
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
