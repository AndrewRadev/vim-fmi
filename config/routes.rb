Rails.application.routes.draw do
  resource :registration, only: %w(new create)
  resources :activations, constraints: {id: /.+/}, only: %w(show update)
  devise_for :users
  resources :users, only: %w(index show)
  resources :sign_ups, only: %w(index create)
  resource :team, only: :show

  resource :dashboard, only: :show
  resource :profile, only: %w(edit update)

  resources :announcements, except: %w(destroy)
  resources :lectures, only: :index

  # Compatibility with vimgolf binary
  get '/challenges/:id.json' => 'tasks#show'
  post '/entry.json' => 'solutions#update'

  resources :tasks, except: :destroy do
    resources :solutions, only: %w(index create show update) do
      get :unscored, on: :collection
    end
    resource :my_solution, only: %w(show)
    # resource :check, controller: :task_checks, only: :create
  end

  resources :activities, only: :index
  resources :points_breakdowns, only: :index

  resources :voucher_claims, only: %w(new create)
  resources :vouchers, only: %w(index new create)

  resource :preview, only: :create

  root "home#index"
end
