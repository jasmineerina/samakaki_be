class CreateFamilyTrees < ActiveRecord::Migration[7.0]
  def change
    create_table :family_trees do |t|
      t.string :name
      t.references :user, index: true
      t.timestamps
    end
  end
end
