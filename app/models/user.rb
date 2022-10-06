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
end
