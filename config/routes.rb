Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/login', to: 'auth#login'

      resources :evaluated, only: [:index, :show, :create, :update]
      resources :instruments, only: [:index, :show, :create]
      resources :evaluations, only: [:create]

      resources :evaluations, only: [:create] do
        post 'send_instrument', on: :member
      end
    end
  end
end
