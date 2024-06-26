class Api::V1::PersonalChatsController < ApplicationController
    before_action :authorize, only: [:create, :sending, :show,:index]

    def index
        @participants = Participant.get(@user)
        response_to_json(@participants, :success)
    end

    def create
        @room = Room.create!(is_private: true)
        @message = Message.new
        @sender = Participant.new(user_id:@user.id, room_id:@room.id)
        @receiver = Participant.new(user_id:params[:user_id], room_id:@room.id)
        if @sender.save && @receiver.save
            @participants = Participant.where(room_id:@room.id)
            response_to_json(@participants, :success)
        else
            response_error({sender:@sender.errors, receiver:@receiver.errors}, :success)
        end
        @room_name = @receiver
    end

    def messages
        @messages = @single_room.messages
        response_to_json(@messages,:success)
    end

    def sending
        @message = Message.create!(user_id:@user.id, room_id:params[:room_id], message:params[:message])
        response_to_json(@message,:success)
    end
end
