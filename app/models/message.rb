class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat
  validates :body, presence: true
  after_create_commit :broadcast_message

  private
    def broadcast_message
      MessageBroadcastJob.perform_later(self)
    end
end
