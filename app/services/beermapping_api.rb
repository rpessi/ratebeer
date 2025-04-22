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
      trim_data(places)
      # places.map do |place|
      #  Place.new(place)
      # end
    rescue ActionDispatch::Cookies::CookieOverflow
      puts "CookieOverflow error"
      { error: "Too many places, try a smaller city." }
    end
  end

  def self.trim_data(places)
    places.map do |place|
      Place.new(id: place["id"], name: place["name"], status: place["status"],
                city: place["city"], street: place["street"], zip: place["zip"])
    end
  end
end
