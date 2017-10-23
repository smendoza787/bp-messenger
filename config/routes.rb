Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  root 'chats#index'
  resources :chats, only: [:index, :new, :create, :show]
end
