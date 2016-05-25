node :message do
	@message
end

node :success do
	@success
end

node(:data) {
	partial("api/sessions/user", :object => @user)
}
