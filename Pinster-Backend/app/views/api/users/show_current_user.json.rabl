node :message do
	''
end

node :success do
	'1'
end

node(:user) {
	partial("api/sessions/user", :object => @current_user)
}