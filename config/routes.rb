Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  root 'chats#index'
  resources :users, only: [:show] do
    resources :chats, only: [:index, :create, :show]
  end
end
