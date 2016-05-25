class AddContactIdToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :contact_id, :integer
  end
end
