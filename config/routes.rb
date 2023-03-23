Rails.application.routes.draw do
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Public games routes
  resources :games, only: [:index, :show] do
    resources :team_selections, only: [:index, :new, :create, :update, :destroy]
  end

  # Private games routes
  resources :private_games, only: [:new, :create, :show, :edit, :update, :destroy]

  # Insights routes
  resources :insights, only: [:index, :show]

  # Root route
  root to: 'homepage#index'
end

