class Api::V1::PersonalChatsController < ApplicationController
    before_action :authorize, only: [:create, :sending, :show,:index]

    def index
        # @rooms = Room.where(is_private: true)
        @participants = Participant.get(@user)
        # @rooms = []
        # @user_participants.map do |user_participant|
        #     @all_rooms = Room.where(id:user_participant.room_id)
        #     @rooms.push(@all_rooms)
        # end     

        # @participants = Participant.where(room_id:)
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

    # def show
    #     # @single_room = Room.find(params[:id])
    #     response_to_json(@single_room.new_attribute, :success)
    # end

    # private
    # def get_name(user1, user2)
    #     users = [user1, user2].sort
    #     "private_#{users.[0].id}_#{users.[1].id}"
    # end
end
