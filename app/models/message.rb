class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat
  validates :body, presence: true
  after_create_commit :broadcast_message, :get_time

  private
  def broadcast_message
    MessageBroadcastJob.perform_later(self)
  end

  def get_time
    @time_created = Time.now
  end
end
