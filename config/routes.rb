Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  devise_for :users, path: '',
    path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'signup' },
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords',
      invitations: 'users/invitations'
  }

  resources :posts, only: [:new, :create, :index, :show] do
    member do
      resources :comments, only: [:create]
    end
  end

  root "posts#index"
end
