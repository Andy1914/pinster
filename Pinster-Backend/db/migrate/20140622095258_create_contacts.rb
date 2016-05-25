class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :user_id
      t.integer :type
      t.integer :status

      t.timestamps
    end
  end
end
