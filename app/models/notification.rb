class Notification < ApplicationRecord
  belongs_to :user_relation
  belongs_to :user
  enum :status, {unread:0, read:1}


  def self.get(user)
    @notifications_unread = Notification.where(user_id: user.id,status:"unread")
    @notifications_read = Notification.where(user_id: user.id,status:"read")
    @notif_unread = []
    @notif_read = []
    @notifications_unread.map do |notif|
      @user_relation = UserRelation.find_by_id(notif.user_relation_id)
      @notif_unread.push(notif.new_attribute)
    end

    @notifications_read.map do |notif|
      @user_relation = UserRelation.find_by_id(notif.user_relation_id)
      @notif_read.push(notif.new_attribute)
    end

    return {unread: @notif_unread, read: @notif_read}
  end

  def new_attribute
    {
      id: self.id,
      status: self.status,
      date: self.created_at.to_s.split(" ")[0],
      time: self.created_at.to_s.split(" ")[1],
      inviting_name: self.user_relation.user.name,
      inviting_email: self.user_relation.user.email,
      relation: self.user_relation.relation.relation_name,
      descriptions: self.descriptions,
      invitation_token: self.user_relation.token
    }
  end
end
