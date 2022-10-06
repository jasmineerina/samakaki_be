class AddUserIdIntoBiodataUser < ActiveRecord::Migration[7.0]
  def change
    add_column :biodata_users, :user_id, :integer
    add_column :posts, :user_id, :integer
  end
end
