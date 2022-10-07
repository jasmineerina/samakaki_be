require 'bcrypt'
class User < ApplicationRecord
  has_one :biodata
  has_many :posts
  validates :email, :presence => true, :uniqueness => true

  include BCrypt

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
      name: self.name,
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
 self.password_digest = password
 save!
end

private

def generate_token
 SecureRandom.hex(10)
end

end