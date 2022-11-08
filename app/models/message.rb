class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates_presence_of :content
  after_create_commit { MessageBroadcastJob.perform_later(self) }
end
