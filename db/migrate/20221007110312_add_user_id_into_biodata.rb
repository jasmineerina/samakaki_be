class AddUserIdIntoBiodata < ActiveRecord::Migration[7.0]
  def change
    add_column :biodata_users, :user_id, :integer
    add_index :biodata_users, :user_id
  end
end
