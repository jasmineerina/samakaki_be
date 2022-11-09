class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :content
  validate :acceptable_image
  validates :content, :presence => false

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
    @relations = UserRelation.where(user_id:user.id)

    @all_posts =[]
    @myposts = Post.where(user_id: user.id)
    @myposts.map do |mypost|
    @all_posts.push(mypost.new_attribute) if mypost !=nil
    end
    @relations.each do |relation,index|
        @posts = Post.where(user_id: relation.connected_user_id)
        @posts.each do |post|
        @all_posts.push(post.new_attribute) if post !=nil
        end
    end
    return @all_posts
  end

  private

  def acceptable_image
    if content.present?
      unless content.byte_size <= 10.megabyte
        errors.add(:content, "ukuran melebihi 10 MB")
      end
    end
  end

end
