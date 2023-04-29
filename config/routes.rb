Rails.application.routes.draw do
  resource :registration, only: %w(new create)
  resources :activations, constraints: {id: /.+/}, only: %w(show update)
  devise_for :users
  resources :users, only: %w(index show) do
    resources :vimrc_revisions, only: %w(index show)
  end
  resources :sign_ups, only: %w(index create)
  resource :team, only: :show

  resource :dashboard, only: :show
  resource :profile, only: %w(edit update) do
    resource :vimrc, only: %w(edit update)
  end

  resources :user_tokens, only: %w(index new create edit update destroy)

  resources :announcements, except: %w(destroy)
  resources :lectures, only: :index

  post '/api/setup.json'              => 'api#user_setup'
  get  '/api/task/:token.json'        => 'api#task'
  get  '/api/free_task/:token.json'   => 'api#free_task'
  post '/api/solution.json'           => 'api#solution'
  post '/api/free_task_solution.json' => 'api#free_task_solution'
  get '/api/vimrc/:token.json'        => 'api#vimrc'

  resources :tasks, except: :destroy do
    resources :solutions, only: %w(index create show update destroy) do
      get :unscored, on: :collection
    end
    resource :my_solution, only: %w(show)
    # resource :check, controller: :task_checks, only: :create
  end

  resources :free_tasks, except: :destroy do
    member do
      put :hide
    end

    resources :free_task_solutions, as: :solutions, only: %w(index create show update destroy) do
      get :unscored, on: :collection
    end
  end

  resources :activities, only: :index
  resources :points_breakdowns, only: :index

  resources :voucher_claims, only: %w(new create)
  resources :vouchers, only: %w(index new create)

  resource :preview, only: :create

  get 'guides/tasks',      as: :task_guide
  get 'guides/free_tasks', as: :free_task_guide
  get 'guides/projects',   as: :projects_guide

  root "home#index"
end
