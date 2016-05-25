class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :user_ids
      t.string :name
      t.integer :owner_id

      t.timestamps
    end
  end
end
