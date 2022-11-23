class Event < ApplicationRecord
    belongs_to :user

    def self.get_all(user)
        @user_relations = UserRelation.get_relation(user)
        @user_relations = @user_relations[:relation].pluck(:id)
        @relations = UserRelation.where(id:@user_relations).pluck(:user_id)
        @connected_relations = UserRelation.where(id:@user_relations).pluck(:connected_user_id)
        @events = Event.where(user_id: @relations+@connected_relations)
        return @events
    end
end
