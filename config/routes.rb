require 'sidekiq/web'
Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  # /sidekiq page

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sideqkic'

    namespace :admin do
      resources :users
      root to: 'users#index'
      resources :submissions
    end
  end

  resources :communities do
    resources :subscriptions
  end

  resources :submissions do
    # resources :comments

    member do
      put 'upvote', to: 'submisson#upvote'
      put 'downvote', to: 'submisson#downvote'
    end

    resources :comments do
      member do
        put 'upvote', to: 'comments#upvote'
        put 'downvote', to: 'comments#downvote'
      end
    end
  end

  # get 'home/index'
  # # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")

  get 'submissions/unsubscribe/:unsubscribe_hash' => 'submissions#unsubscribe', as: :comment_unsubscribe
  get :search, controller: :application
  devise_for :users
  root 'submissions#index'

  resources :profiles, only: :show

  resource :pricing
  resources :checkouts
  resources :premium_subscriptions
  get 'success', to: 'checkouts#success'
  resources :webhooks, only: :create
  resources :billings, only: :create
end
