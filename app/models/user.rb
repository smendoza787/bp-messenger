class User < ApplicationRecord
  include Clearance::User

  has_many :messages, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :chats, through: :subscriptions

  def name
    email.split('@')[0]
  end

  def existing_chats_users
    existing_chat_users = []
    self.chats.each do |chat|
      existing_chat_users.concat(chat.subscriptions.where.not(user_id: self.id).map{ |sub| sub.user })
    end
    existing_chat_users.uniq
  end
end
