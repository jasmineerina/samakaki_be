class Relation < ApplicationRecord
  enum :relation_name, {father:0, mother:1, siblings:2, child:3, grandfather:4,grandmother:5,grandchild:6,husband:7,wife:8}
  enum :position, {right:0, left:1, below:2, above:3}
  has_many :user_relations
  attr_accessor :user_id, :relation_id, :family_tree_id,  :connected_user_id

  after_save :build_user_relation

  def get_relation_from_invitation
    {data:{relation: self,invitaion_token: self.user_relations[0].token},status: :success}
  end
  private

  def  build_user_relation
    token = JWT.encode({user_id: self.user_id, relation_id: self.id},'secret')
    @user_relation = self.user_relations.new(user_id: self.user_id, relation_id: self.id, family_tree_id: self.family_tree_id,connected_user_id: self.connected_user_id,token: token)
    @user_relation.save
  end
end
