Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  resources :users, only: %i(new create show)
  resources :groups
  resources :group_users, only: %i(create destroy)
  namespace :admin do
    resources :users, only: %i(index new create edit update destroy)
  end
  resources :sessions, only: %i(new create destroy)
  resources :labels, only: %i(index create edit update destroy)
end
