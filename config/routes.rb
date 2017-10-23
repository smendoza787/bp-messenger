Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  root 'chats#index'

  resources :messages, only: [:create]
  resources :chats, only: [:index]
end
