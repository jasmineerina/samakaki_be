class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :content
  validate :acceptable_image

  def new_attribute
    {
      id: self.id,
      descriptions: self.descriptions,
      status: self.status,
      content: self.content.url,
      :user =>
      {
        name: self.user.name,
        avatar: self.user.biodata_user.avatar.url
      }
    }
  end

  def self.get(user)
    @relation = UserRelation.find_by(user_id:user.id)
    @relations = UserRelation.where(family_tree_id:@relation.family_tree_id)
    @all_posts =[]
    @relations.each do |relation,index|
        @posts = Post.where(user_id: relation.user_id)
        @posts.each do |post|
        @all_posts.push(@posts[0].new_attribute) if post !=nil
        end
    end
    return @all_posts
  end

  private

  def acceptable_image
    unless content.byte_size <= 10.megabyte
      errors.add(:content, "ukuran melebihi 10 MB")
    end
  end

end
