Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.email == "hello@pranavsingh.me" } do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  %w(404 422 500 503).each do |code|
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

  namespace :admin do
    resources :boards do
      resources :posts, except: [:new, :edit]
    end

    resources :accounts do
      resource :account_memberships, only: [:create, :destroy]
    end

    resources :users, only: [:index, :show, :edit, :update]
    resource :billing, only: [:show], controller: :billing do
      post "consume_paddle_webhook"
    end
  end

  get :join, to: "users#new"
  resources :users, only: [:create, :index]

  health_check_routes

  resources :boards, path: "" do
    resources :posts, only: [:create, :show, :index, :new] do
      resources :comments, only: [:create]
      resource :votes, only: [:create, :destroy]
    end
  end
end
