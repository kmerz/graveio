Fox::Application.routes.draw do
  resources :posts, :as => :p

  match '/help' => 'posts#help', :as => :help
  match '/search' => 'posts#search', :as => :search
  root :to => 'posts#index'
end