Rails.application.routes.draw do
  
  # require 'sidekiq/web'
  # mount Sidekiq::Web, at: '/sidekiq'  
  resources :contacts

  resources :pins

  resources :categories

  devise_for :users, controllers: { registrations: 'registrations',passwords: 'passwords' }  
  get "/auth/:provider/callback" => "omniauth_callbacks#facebook"
  # devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcomes#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  #Api routes starts here#
  namespace :api, defaults: { format: 'json' } do
    devise_for :users#, controllers: { :omniauth_callbacks => "api/omniauth_callbacks"}
    # get "/auth/:provider/callback" => "api/omniauth_callbacks#facebook"
    get 'received_pins' => "pins#received_pins"
    post 'add_pin' => "pins#add_pin"
    put 'share_pin' => "pins#share_this_pin"
    resources :pins
    put 'change_status' => 'contacts#change_status'
    resources :contacts
    resources :categories
    get 'current_user' => 'users#show_current_user'
    put 'send_reset_pasword' => 'users#send_reset_pasword'
    put 'reset_password_by_token' => 'users#reset_password_by_token'
    post "user_create" => "users#user_create"
    get "user_groups" => "users#user_groups"
    put 'update_user' => "users#update_user"
    put 'update_mobile' => "users#update_mobile"
    put 'mobile_verification' => "users#mobile_verification"
    put 'pin_likes' => 'pins#pin_likes'
    post 'facebook_login' => 'users#facebook_login'
    get 'notifications'=> "notifications#notifications"
  end

end
