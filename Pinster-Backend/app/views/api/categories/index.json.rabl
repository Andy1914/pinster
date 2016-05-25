
node :message do
	""
end

node :success do
	"1"
end

node :data do
	@categories.map do |category|
		partial("api/categories/category", :object => category)
	end
end

