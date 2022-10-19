class Post < ApplicationRecord
  belongs_to :user
  ActiveStorage::Current.url_options = "http://res.cloudinary.com"
  has_one_attached :content
end
