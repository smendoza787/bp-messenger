require 'securerandom'

class ChatsController < ApplicationController
  before_action :require_login
  
  def index
    @existing_chats_users = current_user.existing_chats_users
    @other_users = User.all.select{|user| user.id != current_user.id}
  end

  def show
    @other_user = User.find(params[:other_user])
    @chat = Chat.find(params[:id])
    @message = Message.new
  end

  def create
    @other_user = User.find(params[:other_user])
    @chat = find_chat(@other_user) || Chat.new(identifier: SecureRandom.hex)
    if !@chat.persisted?
      @chat.save
      @chat.subscriptions.create(user_id: current_user.id)
      @chat.subscriptions.create(user_id: @other_user.id)
    end
    redirect_to user_chat_path(current_user, @chat, :other_user => @other_user.id)
  end

  private
    def find_chat(other_user)
      my_chats_subs = []
      matching_subs = []
      current_user.chats.each do |chat|
        chat.subscriptions.each do |sub|
          my_chats_subs.push(sub)
        end
      end
      my_chats_subs.each do |sub|
        if sub.user.id == other_user.id
          matching_subs.push(sub)
        end
      end
      if matching_subs.first
        matching_subs.first.chat
      else
        false
      end
    end
end
