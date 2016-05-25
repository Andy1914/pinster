class CreateSharedPins < ActiveRecord::Migration
  def change
    create_table :shared_pins do |t|
      t.integer :user_id
      t.integer :contact_id
      t.integer :pin_id
      t.integer :status

      t.timestamps
    end
  end
end
