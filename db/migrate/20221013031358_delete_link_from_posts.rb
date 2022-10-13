class DeleteLinkFromPosts < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :link
  end
end
