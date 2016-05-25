node :mobile do |u|
	u.mobile? ? u.mobile : ""
end

node :dob do |u|
	u.date_of_birth? ? u.date_of_birth : ""
end

node :name do |u|
	u.name? ? u.name : ""
end


node :pins_create_by_me do |u|
	u.pins.pluck(:id).compact
end


node :profile_picture do |u|
	u.profile_picture? ? u.profile_picture.url.to_s : ""
end

node :id do |u|
	u.id? ? u.id.to_s : ""
end

node :mobile_verification_status do |u|
	u.mobile_verification_status == true ? '1' : '0'
end

node :email do |u|
	u.email? ? u.email : ""
end

node :uid do |u|
	u.uid.present? ? u.uid : ""
end

node :pins_count do |u|
	u.pins.count.to_s
end

node :shared_pins_count do |u|
	SharedPin.where(:contact_id=>u).map{|x| x.pin}.count.to_s
end

node :pins_create_by_me do |u|
	u.pins.pluck(:id).compact
end

node :pins_shared_with_me do |u|
	SharedPin.where(:contact_id=>u).map{|x| x.pin.title}.uniq.flatten.compact
end

node :notification do |u|
	u.notification == true ? '1' : '0' 
end

node :push_notification do |u|
	u.push_notification == true ? '1' : '0'
end