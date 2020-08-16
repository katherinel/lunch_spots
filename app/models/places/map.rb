module Places
  class Map
    def initialize(location)
      @start_location = location
      @place = place
    end

    def place
      Google::Maps.place(place_results.first.place_id)
    end

    private

    def place_results
      Google::Maps.places(@start_location)
    end
  end
end
