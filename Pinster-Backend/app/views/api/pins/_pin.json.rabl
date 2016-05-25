node :id do |u|
	u.id? ? u.id.to_s : ""
end

node :title do |u|
	u.title? ? u.title.to_s : ""
end

node :date do |u|
	u.created_at? ? u.created_at.to_s : ""
end

node :owner_id do |u|
	u.user_id? ? u.user_id.to_s : ""
end

node :longitude do |u|
	u.longitude? ? u.longitude.to_s : ""
end

node :latitude do |u|
	u.latitude? ? u.latitude.to_s : ""
end

node :is_liked do |u|	
	u.user_id.present? ? u.is_liked?(u.user_id) == 1 ? '1' :'0' : '0'
end

node :category_id do |u|
	u.category_id? ? u.category_id.to_s : ""
end

node :location do |u|
	u.location? ? u.location.to_s : ""
end

node :shared_picture do |u|
	u.shared_picture? ? u.shared_picture.url.to_s : ""
end


node :shared_users do |u|
	u.shared_pins.map{|x| x.pin_share.name}
end

node :pin_likes do |u|
	u.pin_like_users.map(&:name).compact
end

node :message do |u|
	u.message.present? ? u.message : ""
end

node :owner_name do |u|
	u.try(:user).try(:name).present? ? u.try(:user).try(:name) : ""
end