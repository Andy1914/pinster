json.array!(@pins) do |pin|
  json.extract! pin, :id, :title, :longitude, :latitude, :category_id
  json.url pin_url(pin, format: :json)
end
