module FilteredTraffic
  extend ActiveSupport::Concern

  private

  def filter_visits
    Ahoy::Visit
      .where.not(ip: FILTERED_IPS)
      .where.not(country: FILTERED_COUNTRIES)
      .where(<<~SQL
        landing_pages: FILTERED_URLS,
        platform_keywords: FILTERED_HOSTNAME_KEYWORDS,
        org_keywords: FILTERED_ORGANIZATION_KEYWORDS,
        ua_keywords: FILTERED_USER_AGENT_KEYWORDS)
        NOT EXISTS (
            SELECT
                1
            FROM
                unnest(:landing_pages) AS lp
            WHERE
                ahoy_visits.landing_page ILIKE '%' || lp || '%')
            AND (ahoy_visits.platform IS NULL
                OR NOT EXISTS (
                    SELECT
                        1
                    FROM
                        unnest(:platform_keywords) AS pk
                    WHERE
                        LOWER(ahoy_visits.platform)
                        LIKE '%' || LOWER(pk) || '%'))
                AND NOT EXISTS (
                    SELECT
                        1
                    FROM
                        unnest(:org_keywords) AS ok
                    WHERE
                        LOWER(ahoy_visits.utm_campaign)
                        LIKE '%' || LOWER(ok) || '%')
                    AND NOT EXISTS (
                        SELECT
                            1
                        FROM
                            unnest(:ua_keywords) AS ua
                        WHERE
                            LOWER(ahoy_visits.user_agent)
                            LIKE '%' || LOWER(ua) || '%')
      SQL
            )
      .reject { |visit| Browser.new(visit.user_agent).bot? }
  end

  def filter_events
    visit_filtered_events = Ahoy::Event.where(visit_id: filter_visits.map(&:id))
    multiple_visit_events = Ahoy::Event.where(
      visit_id: Ahoy::Event.group(:visit_id)
                           .having("COUNT(*) > 1")
                           .pluck(:visit_id)
    )
    (visit_filtered_events + multiple_visit_events).uniq(&:id)
  end

  FILTERED_URLS = %w[
    https://synyster-website.onrender.com/
  ]

  FILTERED_IPS = %w[
    139.99.241.181
    172.200.43.78
    178.197.198.222
    45.252.251.4
    87.251.78.138
  ]

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
    16clouds
    akamaitechnologies
    amazonaws
    cache.google.com
    cagcav.seruhah.com
    cloudwaysstagingapps
    comcast
    compute
    contaboserver
    crawl
    dataproviderbot
    ec2
    fastwebserver
    fbsv
    host
    insidesign
    instances.scw.cloud
    megasrv
    noc223
    npsmanaged
    onyphe
    qwant
    server
    sokloud
    speakwrightspeechpathology
    starlinkisp
    startdedicated
    thoughtlesscracker.ptr.network
    tmdcloud
    unil.cloud.switch.ch
    vps
  ].freeze

  FILTERED_ORGANIZATION_KEYWORDS = [
    "1337 services",
    "3xk tech",
    "aeza international",
    "akamai",
    "alibaba",
    "amazon",
    "atomic networks",
    "bharti airtel",
    "bucklog",
    "centrilogic",
    "cisco systems ironport division",
    "cloud hosting solutions",
    "clouvider",
    "comcast cable communications",
    "contabo",
    "cv andhika pratama sanggoro",
    "da international group ltd.",
    "datacamp limited",
    "detai prosperous technologies limited",
    "digitalocean",
    "facebook, inc.",
    "flokinet ehf",
    "flyservers",
    "frantech solutions",
    "glesys",
    "globalconnect",
    "godaddy",
    "google",
    "hetzner",
    "host",
    "hydra communications",
    "insidesign",
    "instra corporation",
    "internet vikings",
    "internetdienste",
    "ionos",
    "it7 networks inc",
    "keminet shpk",
    "leaseweb",
    "level 3 parent",
    "m247",
    "mass response service",
    "medialink global mandiri",
    "mevspace",
    "microsoft",
    "milkywan association",
    "musarubra",
    "netcup",
    "nybula",
    "onyphe",
    "quickpacket",
    "qwantbot",
    "railnet",
    "rcn",
    "redheberg",
    "serverio technologijos mb",
    "smartnet limited",
    "space exploration technologies corporation",
    "sunucun bilgi iletisim teknolojileri ve ticaret limited sirketi",
    "techoff srv limited",
    "the constant company",
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
