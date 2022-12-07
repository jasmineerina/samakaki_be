class Event < ApplicationRecord
    belongs_to :user

    def self.get_all(user)
        @user_relations = UserRelation.get_relation(user)
        @user_relations = @user_relations[:relation].pluck(:id)
        @relations = UserRelation.where(id:@user_relations).pluck(:user_id)
        @connected_relations = UserRelation.where(id:@user_relations).pluck(:connected_user_id)
        @events = Event.where(user_id: @relations+@connected_relations+[user.id])
        @all_events = []
        @events.map do |event|
          @all_events.push(event.event_attribute)
        end
        return @all_events
    end

    def event_attribute
        {
            id: self.id,
            name: self.name,
            date: self.date.to_s.split(' ')[0],
            time: self.date.to_s.split(' ')[1].split(':')[0]+":"+self.date.to_s.split(' ')[1].split(':')[1],
            venue: self.venue,
            user_id: self.user_id,
        }
    end


end
