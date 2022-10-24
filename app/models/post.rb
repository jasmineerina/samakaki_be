class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :content
  def new_attribute
    {
      id: self.id,
      descriptions: self.descriptions,
      status: self.status,
      content: self.content.url,
    }
  end
end
