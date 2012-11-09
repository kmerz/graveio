Fox::Application.routes.draw do
  # note that the helper methods are still called with 'posts' instead of 'p'
  # for legibility purposes
  resources :posts, :path => :p do
    resources :comments
  end

  match '/help' => 'posts#help', :as => :help
  match '/search' => 'posts#search', :as => :search
  root :to => 'posts#index'
end
