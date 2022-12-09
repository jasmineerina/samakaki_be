class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :content
  validate :acceptable_image
  validates :content, :presence => false
  validates :status, :presence =>true

  def new_attribute
    {
      id: self.id,
      descriptions: self.descriptions,
      status: self.status,
      content: self.content.url,
      :user =>
      {
        name: self.user.name,
        avatar: self.user.biodata_user.try(:avatar).try(:url)
      }
    }
  end

  def self.get_private(user)
    @my_posts = Post.where(user_id: user.id)
    @private_posts = []
    @my_posts.map do |post|
      @private_posts.push(post.new_attribute)
    end
    return @private_posts
  end

  def self.get(user)
    @user_relations = UserRelation.get_relation(user)
    @user_relations = @user_relations[:relation].pluck(:id)
    @relations = UserRelation.where(id:@user_relations).pluck(:user_id)
    @connected_relations = UserRelation.where(id:@user_relations).pluck(:connected_user_id)
    @family_posts = Post.where(user_id: @relations+@connected_relations,status:"public")
    @all_posts =[]
    @myposts = Post.where(user_id: user.id)
    @myposts.map do |mypost|
    @all_posts.push(mypost.new_attribute) if mypost !=nil
    end
    @family_posts.each do |post|
      @all_posts.push(post.new_attribute) if post !=nil
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
