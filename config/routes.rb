require 'sidekiq/web'
Rails.application.routes.draw do
  # /sidekiq page
  mount Sidekiq::Web => '/sideqkic'
  resources :communities do
    resources :subscriptions
  end

  resources :submissions do
    resources :comments

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

  devise_for :users
  root 'submissions#index'

  resources :profiles, only: :show
end
