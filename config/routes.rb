Rails.application.routes.draw do

  root to: 'logs#index'

  resources :users
  get 'users/:id/edit2',    to: 'users#edit2'

  get   'index',            to: 'logs#index'
  match 'show/:log',        to: 'logs#show', via: [:get, :post]
end
