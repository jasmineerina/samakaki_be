class Api::V1::GroupChatsController < ApplicationController
  before_action :authorize, only: [:index,:create,:sending]
  def index
    @rooms = Room.where(is_private: false)
    response_to_json(@rooms,:success)
  end

  def create
    @room = Room.create!(is_private: false)
    @sender = Participant.new(user_id:@user.id,room_id:@room.id)
    @receiver = Participant.new(user_id:params[:user_id],room_id: @room.id)
    if @sender.save && @receiver.save
      @participants = Participant.where(room_id:@room.id)
      response_to_json(@participants,:success)
    else
      response_error({sender:@sender.errors,receiver:@receiver.errors},:success)
    end
  end

  def messages
    @messages = Message.where(room_id: params[:room_id])
    response_to_json(@messages,:success)
  end

  def sending
    @message = Message.create!(user_id:@user.id, room_id:params[:room_id], message:params[:message])
    response_to_json(@message,:success)
  end
end
