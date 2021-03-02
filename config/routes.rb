Rails.application.routes.draw do
  get "/robots.txt", to: "robots_txts#show"

  authenticate :user, lambda { |u| u.email == "hello@pranavsingh.me" } do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  %w[404 422 500 503].each do |code|
    get code, to: "errors#show", code: code
  end

  get :trial_expired, to: "errors#trial_expired", as: :trial_expired

  devise_for :users, path: '',
                     path_names: { sign_in: 'login', sign_up: 'signup' },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations',
                       passwords: 'users/passwords',
                       invitations: 'users/invitations',
                       omniauth_callbacks: "users/omniauth_callbacks"
                     }

  constraints subdomain: 'app' do
    get '/login', to: 'users/sessions#new'
    get '/signup', to: 'users/registrations#new'

    root to: redirect('signup')
  end

  resources :images, only: [:create]

  resource :inbound_emails, only: [] do
    post :consume
  end

  resources :changelog_entries, path: 'changelog', only: [:index, :show]

  namespace :admin do
    resources :changelog_entries, path: 'changelog'
    resource :billing, only: [:show], controller: :billing

    resources :accounts do
      resource :account_memberships, only: [:create, :destroy]
    end

    resources :users, only: [:index, :show, :edit, :update]
    resource :billing, only: [:show], controller: :billing
    resource :integrations, only: [:show], controller: :integrations

    resources :companies, only: [:edit, :update]

    resources :tags, only: [:index]
    post 'tags/search'

    resources :boards, path: "" do
      resources :posts, except: [:new, :edit] do
        post :add_tag
        post :remove_tag
      end
    end
  end

  get :join, to: "users#new"
  resources :users, only: [:create, :index]

  health_check_routes

  post "consume_paddle_webhook", to: "admin/billing#consume_paddle_webhook"

  root to: "roadmaps#index", as: :roadmaps
  get '/boards', to: 'boards#index'
  resources :boards, path: "", except: [:index] do
    resources :posts, only: [:create, :show, :index, :new] do
      resources :comments, only: [:create, :update, :destroy]
      resource :votes, only: [:create, :destroy]
    end
  end

  post "intercom/sheets", to: "intercom#sheets"
  get "intercom/sheets", to: "intercom#sheets"
  post "intercom/initialize", to: "intercom#new"
  post "intercom/configure", to: "intercom#configure"
end
