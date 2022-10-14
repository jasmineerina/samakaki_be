class Relation < ApplicationRecord
  enum :relation_name, {father:0, mother:1, siblings:2, child:3, grandfather:4,grandmother:5,grandchild:6,husband:7,wife:8}
  enum :position, {right:0, left:1, below:2, above:3}
end
