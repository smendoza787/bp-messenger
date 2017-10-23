Rails.application.routes.draw do
  root 'chats#index'

  resources :messages, only: [:create]
  resources :chats, only: [:index]
end
