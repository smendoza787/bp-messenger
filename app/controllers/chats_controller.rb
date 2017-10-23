class ChatsController < ApplicationController
  before_action :require_login
  
  def index
    @messages = Message.order(created_at: :asc)
    @message = Message.new
  end
end
