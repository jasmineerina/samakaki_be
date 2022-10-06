class AddIndexToUserAndBiodataAndPost < ActiveRecord::Migration[7.0]
  def change
    add_index :biodata_users, :user_id
    add_index :posts, :user_id
  end
end
