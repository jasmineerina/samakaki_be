class BiodataUser < ApplicationRecord
  belongs_to :user

  def new_attribute
    {
      dob: self.dob,
      address: self.address,
      marriage_status: self.marriage_status,
      status: self.status
    }
  end
end
