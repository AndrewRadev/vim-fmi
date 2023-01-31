Rails.application.routes.draw do
  devise_for :users
  resources :users, only: %w(index show)
  resource :team, only: :show

  resource :dashboard, only: :show
  resource :profile, only: %w(edit update)

  resources :announcements, except: %w(destroy)
  resources :lectures, only: :index

  resources :tasks, except: :destroy do
    # resources :solutions, only: %w(index show update) do
    #   get :unscored, on: :collection
    # end
    # resource :my_solution, only: %w(show update)
    # resource :check, controller: :task_checks, only: :create
  end

  resources :voucher_claims, only: %w(new create)

  root "home#index"
end
