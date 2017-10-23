class ChatsController < ApplicationController
  before_action :require_login
  
  def index
    @chats = Chat.all
  end

  def show
    @chat = Chat.includes(:messages).find_by(id: params[:id])
  end

  def new
    @chat = Chat.new
  end

  def create
    @chat = current_user.chats.build(chat_params)
    if @chat.save
      flash[:notice] = "Chat room added!"
      redirect_to chat_path(@chat)
    else
      render 'new'
    end
  end

  private
    def chat_params
      params.require(:chat).permit(:name)
    end
end
