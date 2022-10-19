class Post < ApplicationRecord
  belongs_to :user
  ActiveStorage::Current.url_options
  has_one_attached :content
end
