require 'securerandom'

class ChatsController < ApplicationController
  before_action :require_login
  
  def index
    @existing_chats_users = current_user.existing_chats_users
    @other_users = User.all.select{|user| user.id != current_user.id}
  end

  def show
    @chat = Chat.find_by(id: params[:id])
    if @chat
      chat_users = @chat.subscriptions.map{|sub| sub.user.id}
      if !chat_users.include?(current_user.id)
        redirect_to root_path
        flash[:notice] = "Can't access private chat."
      end
      @other_user = User.find(params[:other_user])
      allowed = false
      chat_users.each do |user_id|
        if user_id == @other_user.id
          allowed = true
        end
      end
      if !allowed
        redirect_to root_path
        flash[:notice] = "You're not allowed to do that!"
      end
      @message = Message.new
    else
      redirect_to root_path
      flash[:notice] = "Woops, that chat doesn't exist."
    end
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
