class RemoveFamilyTreeIdOnEvent < ActiveRecord::Migration[7.0]
  def change
    remove_column :events, :family_tree_id
  end
end
