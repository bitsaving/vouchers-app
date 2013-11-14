VoucherApp::Application.routes.draw do
  get "notifications/index"
  get "notifications/seen_notifications"
  # resources :admins
  get 'tags' ,to: 'tags#index'
  get 'tags/:tag', to: 'vouchers#index', as: :tag
  resources :comments

  resources :uploads
  resources :accounts
  root :to => 'users#show'
  # get 'users', to: 'users#index' , :as => :user
  # get 'pending', to: 'vouchers#pending_vouchers' ,:as=> :pending
  # scope 'users/:id' do
    resources :vouchers do
      get 'pending_vouchers',on: :collection
      get 'accepted_vouchers',on: :collection
      get 'rejected_vouchers',on: :collection
      # get "debit_vouchers" ,on: :collection
      # get "credit_vouchers" ,on: :collection
      get 'waiting_for_approval', on: :collection
      post 'increment_state' ,on: :member
      post 'decrement_state',on: :member

    end
    get 'voucher_report' ,to: 'vouchers#report' ,as: :report
    get 'generate_report' ,to: 'vouchers#generate_report'
    namespace 'admin' do
        # get 'users/new' ,to: 'users#new'
        # get 'users',to: 'users#index'
        resources :users
      scope 'users/:id' do
          get 'vouchers', to: 'vouchers#index'
          # post 'edit',to:'users#edit'
      end
    end
 get 'users/:id' ,to: 'users#show'
  devise_for :user, controllers: {
    omniauth_callbacks: "omni_auth/omniauth_callbacks", 
    sessions: "omni_auth/sessions"
  }


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
end
