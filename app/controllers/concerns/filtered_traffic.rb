module FilteredTraffic
  extend ActiveSupport::Concern

  private

  def filter_visits
    sql_filtered = Ahoy::Visit
      .where.not(country: IGNORED_COUNTRIES)
      .where.not(platform: IGNORED_HOSTNAME_KEYWORDS)
      .where.not(utm_campaign: IGNORED_ORGANIZATION_KEYWORDS)
      .where.not(user_agent: nil)
      .where.not(user_agent: IGNORED_USER_AGENT_KEYWORDS)

    sql_filtered.reject { |visit| bot_visit?(visit) }
  end

  def filter_events
    visit_filtered_events = Ahoy::Event.where(visit_id: filter_visits.map(&:id))
    multiple_visit_events = Ahoy::Event.where(
      visit_id: Ahoy::Event .group(:visit_id) .having("COUNT(*) > 1") .pluck(:visit_id)
    )

    (visit_filtered_events + multiple_visit_events)
      .uniq { |event| event.id }
      .sort_by { |event| -event.id }
      .first(100)
  end

  def bot_visit?(visit)
    user_agent = visit.user_agent.to_s.downcase
    hostname = visit.platform.to_s.downcase
    organization_name = visit.utm_campaign.to_s.downcase
    country = visit.country.to_s

    Browser.new(visit.user_agent).bot? ||
    IGNORED_COUNTRIES.include?(country) ||
    IGNORED_HOSTNAME_KEYWORDS.any? { |keyword| hostname.include?(keyword) } ||
    IGNORED_ORGANIZATION_KEYWORDS.any? { |keyword| organization_name.include?(keyword) } ||
    IGNORED_USER_AGENT_KEYWORDS.any? { |keyword| user_agent.include?(keyword) }
  end

  IGNORED_COUNTRIES = %w[
    AU
    CA
    CN
    FI
    HK
    IN
    NL
    PL
    RO
    RU
    SE
    SG
    US
    VN
  ].freeze

  IGNORED_HOSTNAME_KEYWORDS = %w[
    amazonaws
    cloudwaysstagingapps
    compute
    ec2
    fastwebserver
    host
    megasrv
    onyphe
    server
    speakwrightspeechpathology
    startdedicated
    vps
  ].freeze

  IGNORED_ORGANIZATION_KEYWORDS = [
    "amazon",
    "bucklog",
    "cloud hosting solutions",
    "digitalocean",
    "glesys",
    "globalconnect",
    "google",
    "host",
    "hydra communications",
    "instra corporation",
    "internet vikings",
    "internetdienste",
    "ionos",
    "m247",
    "mass response service",
    "medialink global mandiri",
    "mevspace",
    "microsoft",
    "musarubra",
    "netcup",
    "onyphe",
    "redheberg",
    "ucloud",
    "velia.net",
    "wiit"
  ].freeze

  IGNORED_USER_AGENT_KEYWORDS = [
    "chrome/105",
    "chrome/82",
    "chrome/91",
    "headlesschrome",
    "http",
    "mac os x 8_0",
    "phantomjs",
    "puppeteer",
    "python-requests"
  ].freeze
end
