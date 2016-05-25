node :mobile do |u|
	u.mobile.present? ? u.mobile : ""
end

node :id do |u|
	u.id.present? ? u.id.to_s : ""
end

node :mobile_code do |u|
	u.mobile_code.present? ? u.mobile_code : ""
end

node :mobile_verification_status do |u|
	u.mobile_verification_status == true ? '1' : '0'
end