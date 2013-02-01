Fox::Application.routes.draw do
  devise_for :users

  # note that the helper methods are still called with 'posts' instead of 'p'
  # for legibility purposes
  resources :posts, :path => :p do
    resources :comments
    resources :linecomments
    member do
      get :diff
      get :like
      get :dislike
      get :new_line_comment
    end
  end
  resources :posts, :as => :p

  match '/help' => 'posts#help', :as => :help
  match '/search' => 'posts#search', :as => :search
  root :to => 'posts#index'
end
