class DropTableFamilyTree < ActiveRecord::Migration[7.0]
  def change
    drop_table :family_trees
  end
end
