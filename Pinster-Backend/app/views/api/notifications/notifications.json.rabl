node :message do 
 ""
end 

node :success do 
 '1'
end
	node(:data) {
		partial("api/notifications/notification", :object => @notifie)
	}
