Fox::Application.routes.draw do
  resources :posts, :as => :p

  match '/help' => 'posts#help', :as => :help
  match '/search' => 'posts#search', :as => :search
  match 'p/:id' => 'posts#show', :as => :p
  root :to => 'posts#index'
end