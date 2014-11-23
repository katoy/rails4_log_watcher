Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'logs#index'

  resources :users
  get 'users/:id/edit2',    to: 'users#edit2'

  get   'index',            to: 'logs#index'
  match 'show/:log',        to: 'logs#show', via: [:get, :post]

  get   'mydata/edit',      to: 'mydata#edit'
  match 'mydata/create',    to: 'mydata#create', via: [:get, :post]
end
