
attributes :name	

	
node :id do |u|
	u.id? ? u.id.to_s : ""
end

node :image do |u|
	u.image? ? u.image.to_s : ""
end
