require 'bcrypt'
class User < ApplicationRecord
  has_one :biodata_user
  has_many :family_trees
  has_many :posts
  has_many :events
  validates :email, :presence => true, :uniqueness => true
  has_many :user_relations
  include BCrypt
  include EmailValidatable
  validates :email, email: true

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

  private

  def generate_token
   SecureRandom.hex(10)
  end

end
