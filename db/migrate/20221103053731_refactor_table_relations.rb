class RefactorTableRelations < ActiveRecord::Migration[7.0]
  def change
    remove_column :relations, :number
    remove_column :relations, :position
    add_column :relations, :code, :string
  end
end
