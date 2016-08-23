Fox::Application.routes.draw do
  devise_for :users , :controllers => { registrations: 'users/registrations' }

  # note that the helper methods are still called with 'posts' instead of 'p'
  # for legibility purposes
  get "posts/tags" => "posts#tags", :as => :tags

  resources :posts, :path => :p do
    resources :comments
    resources :linecomments
    member do
      get :diff
      get :like
      get :dislike
      get :markdown
      get :parentlist
	  get :search_by_tag
	end
  end
 
  resources :posts, :as => :p

  #get '/search_by_tag' => 'posts#search_by_tag', :as => :search_by_tag
  get '/help' => 'posts#help', :as => :help
  get '/search' => 'posts#search', :as => :search
  root :to => 'posts#index'
end
