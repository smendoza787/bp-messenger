class MessagesController < ApplicationController
  def create
    @message = current_user.messages.new(message_params)
    if @message.save
      redirect_to chats_path
    end
  end

  private
    def message_params
      params.require(:message).permit(:body)
    end
end
