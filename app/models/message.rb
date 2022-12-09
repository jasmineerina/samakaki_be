class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates_presence_of :message
  after_create_commit { MessageBroadcastJob.perform_later(self) }
  before_create :confirm_participant
  
  def confirm_participant
    if self.room.is_private
      is_participant = Participant.where(user_id: self.user.id, room_id: self.room.id).first
      throw :abort unless is_participant
    end
  end
end
