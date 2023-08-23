Rails.application.routes.draw do
  get '/health' => 'health#index'
  namespace :api do
    namespace :v1 do
      post '/signup' => 'users#create'
      post '/login' => 'sessions#create'

      post '/promote' => 'users#promote'
      resources :users, only: %w[update destroy] # Admin
      resources :schedules, only: %w[create update destroy] # Admin
      post '/schedules/order_by_accumulated_hours' => 'schedules#order_by_accumulated_hours' # Admin
      post 'schedules/get_schedule' => 'schedules#get_schedule'
    end
  end
end
