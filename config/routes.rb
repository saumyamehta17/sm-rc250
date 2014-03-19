SmRc250::Application.routes.draw do
  resources :users
  resources :sessions
  resources :articles
  resources :password_resets

  root 'articles#index'
end
