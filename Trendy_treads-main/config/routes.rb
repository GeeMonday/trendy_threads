Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # Devise routes for admin authentication
  devise_for :admin_users, ActiveAdmin::Devise.config

  # Root path
  root 'home#index' # Sets the home page

  # Resources routes
  resources :products, only: [:index, :show]
  resources :categories, only: [:index, :show]
  resources :orders, only: [:index, :show] do
    resources :charges, only: [:create]
  end

  # Cart routes
  resource :cart, only: [:show, :update] do
    post 'add_to_cart'
    delete 'remove/:id', to: 'carts#remove', as: :remove
    get 'checkout'  # This should be GET
    get 'order_confirmation/:id', to: 'orders#confirmation', as: :order_confirmation
    post 'complete_checkout'
  end

  # ActiveAdmin routes
  ActiveAdmin.routes(self)

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Static pages route for specific named pages
  get 'about', to: 'static_pages#about', as: 'about'
  get 'contact', to: 'static_pages#contact', as: 'contact'

  # Route for dynamic static pages with titles
  get 'static/:title', to: 'static_pages#show', as: 'dynamic_static_page'
end
