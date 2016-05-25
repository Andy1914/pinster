class AddPushNotificationToUser < ActiveRecord::Migration
  def change
    add_column :users, :push_notification, :boolean,:default => 1
  end
end
