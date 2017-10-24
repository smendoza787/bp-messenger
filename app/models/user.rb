class User < ApplicationRecord
  include Clearance::User

  has_many :messages, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :chats, through: :subscriptions

  def name
    email.split('@')[0].capitalize!
  end

  def existing_chats_users
    existing_chat_users = []
    self.chats.each do |chat|
      existing_chat_users.concat(chat.subscriptions.where.not(user_id: self.id).map{ |sub| sub.user })
    end
    existing_chat_users.uniq
  end

  def msg_count(current_user)
    match = nil
    current_user.chats.each do |chat1|
      self.chats.each do |chat2|
        if chat1 == chat2
          match = chat1
        end
      end
    end
    if match
      match.messages.length
    else
      match
    end
  end
end
