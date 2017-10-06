Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  constraints subdomain: 'app' do
    devise_for :users, path: '',
      path_names: { sign_in: 'login', sign_up: 'signup' },
      controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations',
        passwords: 'users/passwords',
        invitations: 'users/invitations',
        omniauth_callbacks: "users/omniauth_callbacks"
    }

    root to: redirect('signup')
  end

  devise_scope :user do
    delete "/logout", to: "users/sessions#destroy"
  end

  namespace :admin do
    resources :boards do
      resources :posts, only: [:index, :show, :update]
    end

    resources :accounts, only: [:index, :show, :create] do
      resource :account_memberships, only: [:create, :destroy]
    end
  end

  resources :boards, path: "" do
    resources :posts, only: [:create, :show] do
      resources :comments, only: [:create]
      resource :votes, only: [:create, :destroy]
    end
  end
end
