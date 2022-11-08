class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    payload = {
      room_id: message.room_id,
      message: message.message,
      user_id: message.user_id,
    }
    ActionCable.server.broadcast(build_room_id(message.room_id), payload)
  end

  def build_room_id(id)
    "ChatRoom-#{id}"
  end
end
