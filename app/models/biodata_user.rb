class BiodataUser < ApplicationRecord
  belongs_to :user
  # has_one_attached :avatar
  def new_attribute
    {
      dob: self.dob,
      address: self.address,
      marriage_status: self.marriage_status,
      status: self.status
    }
  end
end
