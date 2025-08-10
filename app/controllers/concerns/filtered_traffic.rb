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
    CN
    FI
    HK
    IN
    RO
    RU
    SE
    SG
    VN
  ].freeze

  FILTERED_HOSTNAME_KEYWORDS = %w[
    amazonaws
    akamaitechnologies
    cloudwaysstagingapps
    compute
    crawl
    dataproviderbot
    insidesign
    ec2
    fastwebserver
    fbsv
    host
    megasrv
    npsmanaged
    onyphe
    qwant
    server
    speakwrightspeechpathology
    starlinkisp
    startdedicated
    tmdcloud
    vps
  ].freeze

  FILTERED_ORGANIZATION_KEYWORDS = [
    "1337 services",
    "amazon",
    "akamai",
    "qwantbot",
    "bharti airtel",
    "bucklog",
    "cloud hosting solutions",
    "da international group ltd.",
    "datacamp limited",
    "digitalocean",
    "flyservers",
    "facebook, inc.",
    "glesys",
    "globalconnect",
    "google",
    "hetzner",
    "host",
    "hydra communications",
    "insidesign",
    "instra corporation",
    "internet vikings",
    "internetdienste",
    "ionos",
    "level 3 parent",
    "m247",
    "mass response service",
    "medialink global mandiri",
    "mevspace",
    "microsoft",
    "musarubra",
    "netcup",
    "nybula",
    "onyphe",
    "ovh sas",
    "quickpacket",
    "railnet",
    "redheberg",
    "space exploration technologies corporation",
    "techoff srv limited",
    "ucloud",
    "uhq services llc",
    "velia.net",
    "wiit"
  ].freeze

  FILTERED_USER_AGENT_KEYWORDS = [
    "chrome/105",
    "chrome/125.0.6422.41",
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
