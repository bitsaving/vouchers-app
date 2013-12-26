VoucherApp::Application.routes.draw do
  get "notifications/index"
  get "notifications/seen"
  get 'tags' ,to: 'tags#index'
  get 'tags/:tag', to: 'vouchers#index', as: :tag, constraints: { tag: /.*/ }
  get 'search' , to: 'vouchers#search' ,as: :search
  get 'auto-complete', to: 'accounts#autocomplete_suggestions', as: :autocomplete
  resources :comments
  resources :uploads
  root :to => 'vouchers#assigned'
  resources :vouchers do
    get 'approved' ,on: :collection
    get 'drafted', on: :collection
    get 'pending', on: :collection
    get 'accepted',on: :collection
    get 'rejected',on: :collection
    get 'archived' , on: :collection
    post 'increment_state' ,on: :member
    post 'decrement_state',on: :member   
  end
  concern :voucher_states do
    get 'vouchers', to: 'vouchers#index'
    get 'vouchers/approved' ,to: 'vouchers#approved'
    get 'vouchers/drafted',   to: 'vouchers#drafted'
    get 'vouchers/pending',to: 'vouchers#pending'
    get 'vouchers/accepted',to: 'vouchers#accepted'
    get 'vouchers/rejected',to: 'vouchers#rejected'
    get 'vouchers/archived' , to: 'vouchers#archived'
    end
  get 'report' ,to: 'reports#report' ,as: :report

  match 'report/generate' ,to: 'reports#generate' ,via: [:post, :get]

  namespace 'admin' do
    resources :users, only: [:show ,:edit,:index,:new,:update,:create ,:destroy]
  end
  resources :users ,concerns: :voucher_states
  resources :accounts ,concerns: :voucher_states
  get 'users/:id' ,to: 'users#show'

  devise_for :user, controllers: {
    omniauth_callbacks: "omni_auth/omniauth_callbacks", 
    sessions: "omni_auth/sessions"
  }
   namespace 'api' do
    resources 'vouchers', only: [:show, :index]
  end

  
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
