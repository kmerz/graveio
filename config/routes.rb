Fox::Application.routes.draw do
  resources :posts

  match 'p/:id' => 'posts#show', :as => :p
  match '/help' => 'posts#help', :as => :help
  root :to => 'posts#index'
end
