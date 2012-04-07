Creamery2012::Application.routes.draw do
 # Routes for main resources
  resources :employees
  resources :assignments
  resources :stores
  resources :shifts
  resources :jobs
  resources :users
  
  # Authentication routes
  match 'user/edit' => 'users#edit', :as => :edit_current_user
  match 'signup' => 'users#new', :as => :signup
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login

  # Semi-static page routes
  match '/about', :to => 'home#about'
  match '/contact', :to => 'home#contact'
  match '/privacy', :to => 'home#privacy'
  match 'home/contact'
  match 'home/privacy'
  match 'home/about'
  match 'home.contact', :to => 'home#contact'
  match 'home.privacy', :to => 'home#privacy'
  match 'home.about', :to => 'home#about'
  match '/home', :to => 'home#home'
  
  # Set the root url
  root :to => 'home#home'
end
