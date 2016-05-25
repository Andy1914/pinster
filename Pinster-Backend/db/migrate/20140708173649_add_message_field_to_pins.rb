class AddMessageFieldToPins < ActiveRecord::Migration
  def change
    add_column :pins, :message, :text
  end
end
