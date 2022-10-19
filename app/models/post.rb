class Post < ApplicationRecord
  belongs_to :user
  ActiveStorage::Current.host = "https://sama-kaki.herokuapp.com/"
  has_one_attached :content
end
