class BeermappingApi
  def self.places_in(city)
    city = city.downcase

    Rails.cache.fetch(city, expires_in: 1.hour) { get_places_in(city) }
  end

  def self.get_places_in(city)
    url = "https://studies.cs.helsinki.fi/beermapping/locations/"

    begin
      response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
      places = response.parsed_response["bmp_locations"]["location"]
      return [] if places.is_a?(Hash) && places['id'].nil?

      places = [places] if places.is_a?(Hash)
      places.map do |place|
        Place.new(place)
      end
    rescue HTTParty::Error => e
      Rails.logger.error "HTTParty error: #{e.message}"
      []
    end
  end
end
