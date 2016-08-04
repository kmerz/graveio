Fox::Application.routes.draw do
  devise_for :users , :controllers => { registrations: 'users/registrations' }

  # note that the helper methods are still called with 'posts' instead of 'p'
  # for legibility purposes
  resources :posts, :path => :p do
    resources :comments
    resources :linecomments
#	collection do
#	  get :tags, as: :tags
#	end
    member do
      get :diff
      get :like
      get :dislike
      get :markdown
      get :parentlist
    end
  end
 
  resources :posts, :as => :p
  resources :tags, only: [:index, :show]

  #get "posts/tags" => "posts#tags", :as => :tags
  get '/help' => 'posts#help', :as => :help
  get '/search' => 'posts#search', :as => :search
  root :to => 'posts#index'
end
