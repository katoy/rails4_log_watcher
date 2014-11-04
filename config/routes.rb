Rails.application.routes.draw do

  root to: 'logs#index'

  get   'index',     to: 'logs#index'
  match 'show/:log', to: 'logs#show', via: [:get, :post]
end
