class Event < ApplicationRecord
    belongs_to :user
    belongs_to :family_tree
end
