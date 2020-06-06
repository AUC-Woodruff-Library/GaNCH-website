module RecipientsHelper
  GOOGLE_MAPS_URL = "https://www.google.com/maps/search/?api=1&"

  # get lat/long out of Point(-81.095169 32.077904)
  def parse_coords(str)
    regex = /(-?\d{1,3}\.\d+)[\s,](\d{1,2}\.\d+)/
    matchData = str.match(regex)
    long, lat = matchData[1], matchData[2]
    [lat, long]
  end

  # return a Google Maps URL for lat/long pair
  def make_location_url(coords)
    lat, long = coords
    return "#{GOOGLE_MAPS_URL}query=#{lat},#{long}"
  end

  # given the whole object, built the map URL
  def make_map_link(location)
    return make_location_url(parse_coords(location))
  end
end
