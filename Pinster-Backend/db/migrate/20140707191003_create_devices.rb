class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :platform
      t.integer :user_id
      t.text :token

      t.timestamps
    end
  end
end
