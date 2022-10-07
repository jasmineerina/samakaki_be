class CreateBiodataUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :biodata_users do |t|
      t.datetime :dob
      t.string :address
      t.string :marriage_status
      t.string :status

      t.timestamps
    end
  end
end
