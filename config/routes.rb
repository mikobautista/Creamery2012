Creamery2012::Application.routes.draw do
  get "password_resets/new"

 # Routes for main resources
  resources :employees
  resources :assignments
  resources :stores
  resources :shifts
  resources :jobs
  resources :users
  resources :sessions
  resources :password_resets
  
  # Authentication routes
  match 'user/edit' => 'users#edit', :as => :edit_current_user
  match 'signup' => 'users#new', :as => :signup
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login

  # Semi-static page routes
  match '/about', :to => 'home#about'
  match '/contact', :to => 'home#contact'
  match '/privacy', :to => 'home#privacy'
  match '/index', :to => 'home#index'
  match '/search', :to => 'home#search'
  match '/home', :to => 'home#index'
  match 'home/about'
  match 'home/contact'
  match 'home/privacy'
  match 'home/index'
  match 'home/search'
  match 'home.about', :to => 'home#about'
  match 'home.contact', :to => 'home#contact'
  match 'home.privacy', :to => 'home#privacy'
  match 'home.index', :to => 'home#index'
  match 'home.search', :to => 'home#search'
  match 'about', :to => 'home#about'
  match 'contact', :to => 'home#contact'
  match 'privacy', :to => 'home#privacy'
  match 'index', :to => 'home#index'
  match 'search', :to => 'home#search'
  
  # Set the root url
  root :to => 'home#index'
end
