class UserRelation < ApplicationRecord
  belongs_to :user
  belongs_to :relation
  belongs_to :family_tree
  validates :connected_user_id, presence: false
  validates :token, presence: false
  enum status: { non_active:0, active:1 }, _default: 0

  def new_attribute
    {
      id: self.id,
      status: self.status,
      user: self.user_id = self.user.new_attribute
    }
  end

  def get_all_data
    {
      "relation": self.relations.map do |relations|
        {
          "name": relations.name,
          "relation_name": relations.relation_name
        }
      end
    }
  end
end
