class UserRelation < ApplicationRecord
  belongs_to :user
  belongs_to :relation
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
    @con_relations_user=[]
    @relations = UserRelation.where(user_id: user.id)
    @relations.map do |relation|
      if relation.connected_user_id == nil
        @detail.push(relation.no_connected_user_id)
      else
        @user_id = User.find_by_id(relation.connected_user_id)
        @detail.push(relation.with_connected_user_id(@user_id))
      end
      @relations_connected_user = UserRelation.where(user_id: relation.connected_user_id).where.not(connected_user_id:user.id)
      @connected_user_relationship = []
      @connected_user = User.where(id:relation.connected_user_id)
      @relations_connected_user.map do |relation_connected_user|
        if relation_connected_user.connected_user_id == nil
          @connected_user_relationship.push(relation_connected_user.no_connected_user_id)
        else
          @user = User.find_by_id(relation_connected_user.connected_user_id)
          @connected_user_relationship.push(relation_connected_user.relation_current_user(@user,relation.relation.code))
        end
        @detail.push(@connected_user_relationship[0])
        @relations_by_connected_user = UserRelation.where(user_id:relation_connected_user.connected_user_id).where.not(connected_user_id: relation_connected_user.user_id)
        # @relations_connected_user_connected = []
        # @relations_by_connected_user.map do |relations_by_connected_user|
        #   if relations_by_connected_user.connected_user_id == nil
        #     @connected_user_relationship.push({connected_user_relationship:relations_by_connected_user.no_connected_user_id})
        #   else
        #     @connected_user = User.where(id:relation_connected_user.connected_user_id)
        #     @user = User.find_by_id(relations_by_connected_user.connected_user_id)
        #     @relations_connected_user_connected.push(relations_by_connected_user.with_connected_user_id(@user))
        #   end
        # end
        # @connected_user_relationship.push({connected_user:@connected_user[0].biodata_user.new_attribute,connected_user_relationship:@relations_connected_user_connected})
      end
    end
    return {current_user:user.name,relation:@detail}
    # return {current_user:user.biodata_user.new_attribute,relation:@detail}
  end

  def relation_current_user(user_id,connected_user)
    {
      id: self.id,
      # user_id: self.user_id,
      # connected_user_id: self.connected_user_id,
      relation_name: self.relation.relation_name,
      code: connected_user+self.relation.code,
      user_related: user_id.name,
    }
  end

  def no_connected_user_id
    {
      id: self.id,
      # user_id: self.user_id,
      # connected_user_id: self.connected_user_id,
      relation: self.relation.name,
      relation_name: self.relation.relation_name,
      code: self.relation.code
    }
  end

  def with_connected_user_id(user_id)
    {
      id: self.id,
      # user_id: self.user_id,
      # connected_user_id: self.connected_user_id,
      relation_name: self.relation.relation_name,
      code: self.relation.code,
      user_related: user_id.name,
    }
  end

  # def
  #   @connected_user = User.find_by_id(relation.connected_user_id)
  #   @relations_connected_user.map do |relation_connected_user|
  #     if relation_connected_user.connected_user_id == nil
  #       @connected_user_relationship.push(relation_connected_user.no_connected_user_id)
  #     else
  #       @user = User.find_by_id(relation_connected_user.connected_user_id)
  #       @connected_user_relationship.push(relation_connected_user.with_connected_user_id(@user))
  #     end
  #   end
  # end
end
