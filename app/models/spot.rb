class Spot < ApplicationRecord

  def self.search_by_location(params)
    lat = '-33.8670522'
    long = '151.1957362'
    client.spots(lat, long, types: :restaurant, name: params[:keyword])
  end

  def self.client
    @_client ||= GooglePlaces::Client.new(Rails.application.credentials.dig(:google_api_key))
  end
end
