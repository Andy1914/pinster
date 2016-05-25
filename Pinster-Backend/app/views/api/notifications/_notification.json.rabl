node :notification_message do |u|
	u[0].present? ? u[0].to_s : ""
end

node :notification_type do |u|
	u[1].present? ? u[1].to_s : ""
end

node :notification_date do |u|
	u[2].present? ? u[2].to_s : ""
end

node :notification_from_id do |u|
	u[3].present? ? u[3].to_s : ""
end

