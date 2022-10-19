class Post < ApplicationRecord
  belongs_to :user
  ActiveStorage::Current.host = "http://res.cloudinary.com"
  has_one_attached :content
end
