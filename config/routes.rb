Fox::Application.routes.draw do
  devise_for :users , :controllers => { registrations: 'users/registrations' }

  # note that the helper methods are still called with 'posts' instead of 'p'
  # for legibility purposes
  resources :posts, :path => :p do
    resources :comments
    resources :linecomments
    member do
      get :diff
      get :like
      get :dislike
    end
  end
  resources :posts, :as => :p

  get '/help' => 'posts#help', :as => :help
  get '/search' => 'posts#search', :as => :search
  root :to => 'posts#index'
end
