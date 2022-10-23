class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :date
      t.string :venue
      t.datetime :time
      t.references :user, index: :true
      t.references :family_tree, index: true

      t.timestamps
    end
  end
end
