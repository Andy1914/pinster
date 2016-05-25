class AddSharedPictureToPins < ActiveRecord::Migration
  def change
    add_column :pins, :shared_picture, :text
  end
end
