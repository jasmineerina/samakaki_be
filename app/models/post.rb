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
    }
  end

  private

  def acceptable_image
    unless content.byte_size <= 1.megabyte
      errors.add(:content, "is too big")
    end
    acceptable_types = ["image/jpeg", "image/png", "image/gif"]
    unless acceptable_types.include?(content.content_type)
      errors.add(:content, "must be a JPEG, PNG or GIF")
    end
  end
end
