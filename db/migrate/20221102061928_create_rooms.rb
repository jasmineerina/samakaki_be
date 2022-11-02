class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.boolean :is_private

      t.timestamps
    end
  end
end
