class RoomChannel < ApplicationCable::Channel
  def subscribed
    if params[:room_id].present?
      stream_from("ChatRoom-#{(params[:room_id])}")
    end
  end

  # calls when a client broadcasts data
  def speak(data)
    Message.create!(
      room_id: params[:room_id],
      user_id: sender,
      message: message
    )
  end
end
