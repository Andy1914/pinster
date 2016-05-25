
@user_notification.each do |notification|
	node(:data) {
		partial("api/notifications/notification", :object => notification)
	}

end
