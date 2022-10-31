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
    unless content.byte_size <= 10.megabyte
      errors.add(:content, "ukuran melebihi 10 MB")
    end
  end

end
