class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat
  validates :body, presence: true
  after_create_commit :broadcast_message, :get_time

  def belongs_to_user?(user)
    if self.user.id == user.id
      true
    else
      false
    end
  end

  private
  def broadcast_message
    MessageBroadcastJob.perform_later(self)
  end

  def get_time
    @time_created = Time.now
  end
end
