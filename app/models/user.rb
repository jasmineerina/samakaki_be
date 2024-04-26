require 'bcrypt'
class User < ApplicationRecord
  has_one :biodata_user, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :events, dependent: :destroy
  validates :email, :presence => true, :uniqueness => true
  has_many :user_relations, dependent: :destroy
  has_many :relations, through: :user_relations
  has_many :notifications
  has_many :messages
  has_many :participants
  include BCrypt
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  before_create :confirmation_token
  
  def password
    @password ||= Password.new(password_digest)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_digest = @password
  end

  def new_attribute
    {
      id: self.id,
      email: self.email,
      name: self.name
    }
  end

  def generate_password_token!
   self.reset_password_token = generate_token
   self.reset_password_sent_at = Time.now.utc
   save!
  end

  def password_token_valid?
   (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password)
   self.reset_password_token = nil
   self.password = password
   save!
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end

  # def get_all_relations level=0
  #   user_levels = []
  #   case level
  #   when 0
  #     user_levels = user_relations.map(&:connected_user_id).compact
  #   when 1
  #     user_levels = get_all_connected_users(user_relations.map(&:connected_user_id).compact)
  #   when 2
  #     user_levels =
  #   when 3
  #   Relation.joins("left join user_relations ON user_relations.relation_id = relations.id")
  #           .where("user_relations.connected_user_id IN (:user_ids)", user_ids: user_levels)
  # end

  private

  def generate_token
   SecureRandom.hex(10)
  end

  def confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end
end
