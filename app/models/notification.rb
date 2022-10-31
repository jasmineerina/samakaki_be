class Notification < ApplicationRecord
  belongs_to :user_relation
  belongs_to :user
end
