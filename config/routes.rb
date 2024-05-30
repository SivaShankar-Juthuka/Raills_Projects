Rails.application.routes.draw do
  # default routes
  get 'about', to: 'home#about'
  root 'home#index' # Corrected route for tasks index page

  # Sign Up routes
  get 'signup', to: 'registrations#new'
  post 'signup', to: 'registrations#create'

  # Login Pages
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'

  delete 'logout', to: 'sessions#destroy'

  # edit password
  get 'editpassword', to: 'passwords#edit', as: :'editpassword'
  patch 'editpassword', to: 'passwords#update'

  # tasks
  resources :tasks

  resources :tasks do
    member do
      get 'assign', to: 'tasks#assign'
      post 'assign', to: 'tasks#assign'
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
