class User < ApplicationRecord
  include Clearance::User

  has_many :chats, dependent: :destroy
  has_many :messages, dependent: :destroy
end
