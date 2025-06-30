class Ahoy::Store < Ahoy::DatabaseStore
  def track_visit(data)
    results = Geocoder.search(data[:ip])
    result = results.first

    if result
      data[:country] = result.country
      data[:region] = result.state || result.region
      data[:city] = result.city
      data[:latitude] = result.latitude
      data[:longitude] = result.longitude
    end

    super(data) # call the original DatabaseStore method to save
  end
end

Ahoy.server_side_visits = :immediate

# set to true for JavaScript tracking
Ahoy.api = false

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = false

Ahoy.exclude_method = lambda do |controller, request|
  user_agent = request.user_agent.to_s.downcase
  browser = Browser.new(user_agent)
  geocoded_result = Geocoder.search(request.remote_ip)
  user_country = geocoded_result.first&.country_code
  blocked_countries = [
    "IN",
    "RO",
    "RU",
    "US"
  ]

  browser.bot? ||
  user_agent.include?("cron-job.org") ||
  user_agent.include?("headless") ||
  request.remote_ip == "::1" ||
  blocked_countries.include?(user_country)
end

Ahoy.track_bots = false
