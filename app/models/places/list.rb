module Places
  class List
    def initialize(place, keyword = nil)
      @place = place
      @keyword = keyword
      @results = results
    end

    def results
      search_params = { types: ['restaurant'] }
      search_params.merge!(name: @keyword) if @keyword
      list = Places.client.spots(@place.latitude, @place.longitude, search_params)
      list.map do |result|
        {
          name: result.name,
          address: result.formatted_address,
          lat_long: "#{result.lat},#{result.lng}",
          rating: result.rating,
          photo_url: result.photos&.first&.fetch_url(800)
        }
      end
    end
  end
end

# place = Places::Map.new('123 main st ny').place
# spots = Places::List.new(place)
