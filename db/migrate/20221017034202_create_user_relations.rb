class CreateUserRelations < ActiveRecord::Migration[7.0]
  def change
    create_table :user_relations do |t|
      t.integer :connected_user_id
      t.integer :status
      t.integer :family_tree_id
      t.string :token
      t.references :user, null: false, foreign_key: true
      t.references :relation, null: false, foreign_key: true
      t.timestamps
    end
  end
end
