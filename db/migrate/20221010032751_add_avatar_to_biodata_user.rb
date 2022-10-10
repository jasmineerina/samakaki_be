class AddAvatarToBiodataUser < ActiveRecord::Migration[7.0]
  def change
    add_column :biodata_users, :avatar, :string
  end
end
