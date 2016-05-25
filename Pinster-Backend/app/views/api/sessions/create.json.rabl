node(:success) { "1" }
node(:message) { "Logged in" }

node :data do
	partial("api/sessions/user", :object => @resource)
end

