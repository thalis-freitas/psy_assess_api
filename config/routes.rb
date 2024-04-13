Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/login', to: 'auth#login'

      resources :evaluated, only: [:index, :show, :create, :update]
      resources :instruments, only: [:index, :show, :create]
    end
  end
end
