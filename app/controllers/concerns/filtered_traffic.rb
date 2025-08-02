module FilteredTraffic
  extend ActiveSupport::Concern

  private

  def filter_visits
    sql_filtered = Ahoy::Visit
      .where.not(country: FILTERED_COUNTRIES)
      .where(
        Ahoy::Visit.arel_table[:platform].matches_any(
          FILTERED_HOSTNAME_KEYWORDS.map { |keyword| "%#{keyword.downcase}%" }
        ).not.or(Ahoy::Visit.arel_table[:platform].eq(nil))
      )
      .where.not(
        FILTERED_ORGANIZATION_KEYWORDS.map { |keyword| "LOWER(utm_campaign) LIKE ?" }.join(" OR "),
        *FILTERED_ORGANIZATION_KEYWORDS.map { |keyword| "%#{keyword.downcase}%" }
      )
      .where.not(
        FILTERED_USER_AGENT_KEYWORDS.map { |keyword| "LOWER(user_agent) LIKE ?" }.join(" OR "),
        *FILTERED_USER_AGENT_KEYWORDS.map { |keyword| "%#{keyword.downcase}%" }
      )

    sql_filtered.reject { |visit| Browser.new(visit.user_agent).bot? }
  end

  def filter_events
    visit_filtered_events = Ahoy::Event.where(visit_id: filter_visits.map(&:id))
    multiple_visit_events = Ahoy::Event.where(
      visit_id: Ahoy::Event .group(:visit_id) .having("COUNT(*) > 1") .pluck(:visit_id)
    )

    (visit_filtered_events + multiple_visit_events)
      .uniq { |event| event.id }
  end

  FILTERED_COUNTRIES = %w[
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

  FILTERED_HOSTNAME_KEYWORDS = %w[
    amazonaws
    qwant
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

  FILTERED_ORGANIZATION_KEYWORDS = [
    "amazon",
    "qwantbot",
    "bucklog",
    "cloud hosting solutions",
    "digitalocean",
    "flyservers",
    "glesys",
    "globalconnect",
    "google",
    "hetzner",
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

  FILTERED_USER_AGENT_KEYWORDS = [
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
