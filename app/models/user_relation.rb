class UserRelation < ApplicationRecord
  belongs_to :user
  belongs_to :relation
  belongs_to :family_tree
  validates :connected_user_id, presence: false
  validates :token, presence: false
  has_many :notifications
  enum status: { non_active:0, active:1 }, _default: 0

  def new_attribute
    {
      id: self.id,
      status: self.status,
      user: self.user_id = self.user.new_attribute
    }
  end


  def self.get_relation(user)
    @detail =[]
    @relations = UserRelation.where(user_id: user.id)
    @relations.map do |relation|
      if relation.connected_user_id == nil
        @detail.push(relation.no_connected_user_id)
      else
        @user_id = User.find_by_id(relation.connected_user_id)
        @detail.push(relation.with_connected_user_id(@user_id))
      end
      @relations_connected_user = UserRelation.where(user_id: relation.connected_user_id)
      @connected_user_relationship = []
      @connected_user = User.find_by_id(relation.connected_user_id)
      @connected_user_relationship.push(connected_user:@connected_user)
      @relations_connected_user.map do |relation_connected_user|
        if relation_connected_user.connected_user_id == nil
          @connected_user_relationship.push(relation_connected_user.no_connected_user_id)
        else
          @user = User.find_by_id(relation_connected_user.connected_user_id)
          @connected_user_relationship.push(relation_connected_user.with_connected_user_id(@user))
        end
      end
    end
    return {current_user:user,relation:@detail,connected_user_relationship:@connected_user_relationship}
  end

  def no_connected_user_id
    {
      user_relation_id: self.id,
      user_id: self.user_id,
      connected_user_id: self.connected_user_id,
      status: self.status,
      family_tree: self.family_tree.name,
      relation: self.relation.name,
      relation_name: self.relation.relation_name,
      position: self.relation.position,
      number: self.relation.number
    }
  end

  def with_connected_user_id(user_id)
    {
      user_relation_id: self.id,
      user_id: self.user_id,
      connected_user_id: self.connected_user_id,
      status: self.status,
      family_tree: self.family_tree.name,
      relation_name: self.relation.relation_name,
      position: self.relation.position,
      number: self.relation.number,
      user_related: user_id.name,
      user_related_id: user_id.id,
      avatar: user_id.biodata_user.avatar.url
    }
  end
end
