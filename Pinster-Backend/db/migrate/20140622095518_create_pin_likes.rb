class CreatePinLikes < ActiveRecord::Migration
  def change
    create_table :pin_likes do |t|
      t.integer :user_id
      t.integer :pin_id
      t.integer :status

      t.timestamps
    end
  end
end
