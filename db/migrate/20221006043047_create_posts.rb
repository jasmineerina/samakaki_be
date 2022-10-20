class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :descriptions
      t.string :status
      t.references :user, index: true

      t.timestamps
    end
    add_foreign_key :posts, :users
  end
end
