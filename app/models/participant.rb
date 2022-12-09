class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :room

  def self.get(user)
    @user_participants = Participant.where(user_id:user.id)
    @rooms = []
    @users = []
    @user_participants.map do |user_participant|
        @all_rooms = Room.where(id:user_participant.room_id)
        @all_rooms.map do |room|

          @participant_chats = Participant.where("room_id = ? and user_id != ?", room.id, user.id)
          @participant_chats.map do |participant_chats|
            @users.push(participant_chats.new_attribute)
          end
        end

    end  
    return @users 
  end

  def new_attribute
    {
      id: self.id,
      user_id: self.user_id,
      name: self.user.name,
      room_id: self.room_id,
    }
  end
end
