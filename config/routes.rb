Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  resources :users, only: %i(new create show)
  namespace :admin do
    resources :users, only: %i(index new create edit update destroy)
  end
  resources :sessions, only: %i(new create destroy)
end
