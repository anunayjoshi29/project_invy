Rails.application.routes.draw do
  get '/health' => 'health#index'
  namespace :api do
    namespace :v1 do
      post '/signup' => 'users#create'
      post '/login' => 'sessions#create'

      resources :schedules, only: [:index] # Staff User
      get '/schedules/work_hours_by_period' => 'schedules#work_hours_by_period' # Staff User
      get '/schedules/coworker_schedule' => 'schedules#coworker_schedule'
      post '/promote' => 'users#promote'
      resources :users, only: %w[index update destroy] # Admin
      resources :schedules, only: %w[create update destroy] # Admin
      post '/schedules/order_by_accumulated_hours' => 'schedules#order_by_accumulated_hours' # Admin
      post 'schedules/get_schedule' => 'schedules#get_schedule'
    end
  end
end
