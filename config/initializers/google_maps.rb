Google::Maps.configure do |config|
  config.authentication_mode = Google::Maps::Configuration::API_KEY
  config.api_key = Rails.application.credentials.dig(:google_api_key)
  config.default_params = {
    directions_service: {
      mode: 'walking'
    }
  }
end
