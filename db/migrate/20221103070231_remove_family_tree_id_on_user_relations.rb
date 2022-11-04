class RemoveFamilyTreeIdOnUserRelations < ActiveRecord::Migration[7.0]
  def change
    remove_column :user_relations, :family_tree_id
  end
end
