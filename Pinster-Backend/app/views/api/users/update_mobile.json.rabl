node :message do
	@message
end

node :success do
	@success
end
if @message_from_twillo.present?
	node :message_from_twilio do
		@message_from_twillo  
	end
end


node(:data) do 
	partial("api/users/mobile", :object => @user)
end