Fox::Application.routes.draw do
  devise_for :users

  # note that the helper methods are still called with 'posts' instead of 'p'
  # for legibility purposes
  resources :posts, :path => :p do
    resources :comments
    member do
      get :diff
    end
  end
  resources :posts, :as => :p

  match '/help' => 'posts#help', :as => :help
  match '/search' => 'posts#search', :as => :search
  root :to => 'posts#index'
end
