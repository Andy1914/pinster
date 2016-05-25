class CreatePins < ActiveRecord::Migration
  def change
    create_table :pins do |t|
      t.string :title
      t.float :longitude
      t.float :latitude
      t.string :location
      t.integer :category_id
      t.integer :user_id
      t.integer :status 
      t.timestamps
    end
  end
end
