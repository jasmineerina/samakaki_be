class CreateRelations < ActiveRecord::Migration[7.0]
  def change
    create_table :relations do |t|
      t.string :name
      t.integer :relation_name
      t.integer :position
      t.integer :number
      t.timestamps
    end
  end
end
