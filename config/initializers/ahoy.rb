require "resolv"

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
      data[:utm_campaign] = result.data["org"]
    end

    # Store hostname in "platform"
    begin
      hostname = Resolv.getname(data[:ip])
      data[:platform] = hostname
    rescue Resolv::ResolvError, Resolv::ResolvTimeout
      data[:platform] = nil
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
  user_agent.include?("cron-job.org")
end
Ahoy.track_bots = true
