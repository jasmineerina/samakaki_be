class BiodataUser < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar
  validate :acceptable_image
  validates :dob, presence: true
  validates :address, presence: true

  def new_attribute
    {
      name: self.user.name,
      email: self.user.email,
      phone: self.user.phone,
      dob: self.dob,
      address: self.address,
      marriage_status: self.marriage_status,
      status: self.status,
      avatar: self.avatar.url
    }
  end

  private

  def acceptable_image
    unless avatar.byte_size <= 1.megabyte
      errors.add(:avatar, "ukuran file melebihi 1 MB")
    end
    acceptable_types = ["image/jpeg", "image/png", "image/gif","image/jpg"]
    unless acceptable_types.include?(avatar.content_type)
      errors.add(:content, "tipe file harus JPEG, PNG, JPG atau GIF")
    end
  end
end
