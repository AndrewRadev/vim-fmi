Rails.application.routes.draw do
  devise_for :users
  resources :users, only: %w(index show)
  resource :team, only: :show

  resources :announcements, except: %w(destroy)
  resources :lectures, only: :index

  resources :tasks, except: :destroy do
    # resources :solutions, only: %w(index show update) do
    #   get :unscored, on: :collection
    # end
    # resource :my_solution, only: %w(show update)
    # resource :check, controller: :task_checks, only: :create
  end

  root "home#index"
end
