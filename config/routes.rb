Rails.application.routes.draw do
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Public games routes
  resources :games, only: [:index, :show, :new, :create, :edit, :update] do
    get 'new_public_game', on: :collection
    post 'create_public_game', on: :collection
    resources :games_enrollments
    resources :team_selections, only: [:index, :new, :create, :update, :destroy] do
      collection do
        get 'fetch_fixtures'
      end
    end
  end

  # Private games routes
  resources :private_games, only: [:new, :create, :show, :edit, :update, :destroy]

  # Insights routes
  resources :insights, only: [:index, :show]

  # Rules routes
  resources :rules, only: [:index]

  # Root route
  root to: 'homepage#index'
end
