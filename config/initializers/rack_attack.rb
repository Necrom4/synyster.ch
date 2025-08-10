if Rails.env.production?
  class Rack::Attack
    ### Configure Cache ###

    # If you don't want to use Rails.cache (Rack::Attack's default), then
    # configure it here.
    #
    # Note: The store is only used for throttling (not blocklisting and
    # safelisting). It must implement .increment and .write like
    # ActiveSupport::Cache::Store

    # Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

    ### Throttle Spammy Clients ###

    # If any single client IP is making tons of requests, then they're
    # probably malicious or a poorly-configured scraper. Either way, they
    # don't deserve to hog all of the app server's CPU. Cut them off!
    #
    # Note: If you're serving assets through rack, those requests may be
    # counted by rack-attack and this throttle may be activated too
    # quickly. If so, enable the condition to exclude them from tracking.

    # Throttle all requests by IP (60rpm)
    #
    # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}"
    throttle("req/ip", limit: 300, period: 5.minutes) do |req|
      req.ip # unless req.path.start_with?('/assets')
    end

    throttle("req/ip", limit: 4, period: 5.seconds) do |req|
      req.ip # unless req.path.start_with?('/assets')
    end

    ### Prevent Brute-Force Login Attacks ###

    # The most common brute-force login attack is a brute-force password
    # attack where an attacker simply tries a large number of emails and
    # passwords to see if any credentials match.
    #
    # Another common method of attack is to use a swarm of computers with
    # different IPs to try brute-forcing a password for a specific account.

    # Throttle POST requests to /login by IP address
    #
    # Key: "rack::attack:#{Time.now.to_i/:period}:logins/ip:#{req.ip}"
    throttle("logins/ip", limit: 5, period: 20.seconds) do |req|
      if req.path == "/login" && req.post?
        req.ip
      end
    end

    # Throttle POST requests to /login by email param
    #
    # Key: "rack::attack:#{Time.now.to_i/:period}:logins/email:#{normalized_email}"
    #
    # Note: This creates a problem where a malicious user could intentionally
    # throttle logins for another user and force their login requests to be
    # denied, but that's not very common and shouldn't happen to you. (Knock
    # on wood!)
    throttle("logins/email", limit: 5, period: 20.seconds) do |req|
      if req.path == "/login" && req.post?
        # Normalize the email, using the same logic as your authentication process, to
        # protect against rate limit bypasses. Return the normalized email if present, nil otherwise.
        req.params["email"].to_s.downcase.gsub(/\s+/, "").presence
      end
    end

    ### Custom Throttle Response ###

    # By default, Rack::Attack returns an HTTP 429 for throttled responses,
    # which is just fine.
    #
    # If you want to return 503 so that the attacker might be fooled into
    # believing that they've successfully broken your app (or you just want to
    # customize the response), then uncomment these lines.
    # self.throttled_responder = lambda do |env|
    #  [ 503,  # status
    #    {},   # headers
    #    ['']] # body
    # end

    BLOCKED_PATHS = %w[
      /.DS_Store
      /.env
      /.git
      /.git/config
      /.gitignore
      /.tmb
      /.well-known
      /.wp-cli
      /about.php
      /about.PHP
      /wp-admin
      /wp-login.php
    ]

    BLOCKED_IPS = %w[
      45.252.251.4
      87.251.78.138
    ]

    BLOCKED_COUNTRIES = %w[
      CN
      RU
      VN
    ].freeze

    BLOCKED_HOSTNAME_KEYWORDS = %w[
      akamaitechnologies
      host
      qwant
    ].freeze

    BLOCKED_ORGANIZATION_KEYWORDS = [
      "akamai",
      "cloud hosting solutions",
      "bharti airtel",
      "datacamp limited",
      "host",
      "railnet",
      "space exploration technologies corporation",
      "techoff srv limited"
    ].freeze

    BLOCKED_USER_AGENT_KEYWORDS = [
      "chrome/125.0.6422.41" # Bot using multi IPs from different countries at second-intervals using Wifi providers; "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.6422.41 Safari/537.36"
    ].freeze

    Rack::Attack.blocklist("block by match in suspicious lists") do |req|
      ip = req.ip
      user_agent = req.user_agent.to_s.downcase
      hostname = req.host.to_s.downcase
      BLOCKED_PATHS.any? { |path| req.path.start_with?(path) } ||
      BLOCKED_IPS.any? { |bad| ip.include?(bad) } ||
      BLOCKED_HOSTNAME_KEYWORDS.any? { |keyword| hostname.include?(keyword) } ||
      BLOCKED_USER_AGENT_KEYWORDS.any? { |keyword| user_agent.include?(keyword) }
    end

    ActiveSupport::Notifications.subscribe("rack.attack") do |name, start, finish, request_id, payload|
      req = payload[:request]
      Rails.logger.info("Rack::Attack blocked request: method=#{req.request_method} path=#{req.path} ip=#{req.ip}")
    end
  end
end
