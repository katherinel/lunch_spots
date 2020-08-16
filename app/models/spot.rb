class Spot < ApplicationRecord
  def self.search_by_location(location, keyword = nil)
    begin
      place = Places::Map.new(location).place
    rescue StandardError => _e
      Rails.logger.error('Could not locate that address')
    end

    Places::List.new(place, keyword).results
  end
end
