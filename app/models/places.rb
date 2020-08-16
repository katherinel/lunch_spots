module Places
  def self.client
    @_client ||= GooglePlaces::Client.new(Rails.application.credentials.dig(:google_api_key))
  end
end
