Rails.application.routes.draw do
  resources :memberships do
    post 'toggle_membership', on: :member
  end
  resources :beer_clubs
  resources :users do
    post 'toggle_status', on: :member
    get 'recommendation', on: :member
  end
  root 'breweries#index'
  resources :beers
  resources :styles do
    get 'about', on: :collection
  end
  resources :breweries do
    post 'toggle_activity', on: :member
    get 'active', on: :collection
    get 'retired', on: :collection
  end
  resources :ratings do
    post 'toggle_arrow', on: :collection
  end
  resources :ratings, only: [:index, :new, :create, :destroy]
  resources :places, only: [:index]
  resource :session, only: [:new, :create, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # get 'test_sentry', to: 'application#test_sentry'
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get 'kaikki_bisset', to: 'beers#index'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  post 'places', to: 'places#search'
  get 'beerlist', to: 'beers#list'
  get 'brewerylist', to: 'breweries#list'
end
