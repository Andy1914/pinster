object false

node :message do
	''
end

node :success do
	'1'
end

	
node :received_pins do
	@pins.map do |pin|
		partial("api/pins/pin", :object => pin)
	end
end

