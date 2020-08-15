class Spot < ApplicationRecord

  def initialize(location:)
    @starting_location = location
  end

  def self.search_by_location(params)
    spot = new(location: params[:location])
    results = client.spots(spot.place.latitude, spot.place.longitude, types: :restaurant, name: params[:keyword])
    results.map do |result|
      # result_location = result.json_result_object['geometry']['location']
      {
        name: result[:name],
        # photo_url: spot.photos[0].fetch_url(800)
        # distance: spot.distance(result_location['lat'], result_location['lng'])
      }
    end
  end

  def self.client
    @_client ||= GooglePlaces::Client.new(Rails.application.credentials.dig(:google_api_key))
  end

  def place
    Google::Maps.place(place_results.first.place_id)
  end

  def place_results
    Google::Maps.places(@starting_location)
  end

  # def distance(endpoint_lat, endpoint_long)
  #   Google::Maps.distance("#{place.latitude},#{place.longitude}", "#{endpoint_lat},#{endpoint_long}")
  # end
end
