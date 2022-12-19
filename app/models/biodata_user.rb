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

  def self.find_one_family(user,id)
    @user_relations = UserRelation.get_relation(user)
    @user = @user_relations[:relation].find{ |item| item[:user_id]==id.to_i}
    if @user != nil
      @biodata = BiodataUser.find_by(user_id: @user[:user_id],status: "public")
      return @biodata.new_attribute unless @biodata==nil
    end
  end

  private

  def acceptable_image
    unless avatar.byte_size <= 1.megabyte
      errors.add(:avatar, "ukuran file melebihi 1 MB")
    end
    acceptable_types = ["image/jpeg", "image/png", "image/gif","image/jpg"]
    unless acceptable_types.include?(avatar.content_type)
      errors.add(:content, "tipe file harus JPEG, PNG atau GIF")
    end
  end

end
