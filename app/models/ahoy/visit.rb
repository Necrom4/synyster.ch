class Ahoy::Visit < ApplicationRecord
  self.table_name = "ahoy_visits"

  has_many :events, class_name: "Ahoy::Event"
  belongs_to :user, optional: true

  scope :filtered, -> {
    where.not(ip: FILTERED_IPS)
      .where.not(country: FILTERED_COUNTRIES)
      .where.not("landing_page ILIKE ANY (ARRAY[?]::text[])", FILTERED_URLS.map { |s| "%#{s}%" })
      .where("(platform IS NULL OR NOT LOWER(platform) LIKE ANY (ARRAY[?]::text[]))", FILTERED_HOSTNAME_KEYWORDS.map { |s| "%#{s.downcase}%" })
      .where.not("LOWER(utm_campaign) LIKE ANY (ARRAY[?]::text[])", FILTERED_ORGANIZATION_KEYWORDS.map { |s| "%#{s.downcase}%" })
      .where.not("LOWER(user_agent) LIKE ANY (ARRAY[?]::text[])", FILTERED_USER_AGENT_KEYWORDS.map { |s| "%#{s.downcase}%" })
      .reject { |v| Browser.new(v.user_agent).bot? }
  }

  FILTERED_URLS = %w[
    https://synyster-website.onrender.com/
  ].freeze

  FILTERED_IPS = %w[
    139.99.241.181
    172.200.43.78
    178.197.198.222
    45.252.251.4
    87.251.78.138
  ].freeze

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
    hawsabah.sa
    host
    insidesign
    instances.scw.cloud
    megasrv
    noc223
    npsmanaged
    onyphe
    qwant
    registerdomain.net.za
    server
    sokloud
    speakwrightspeechpathology
    starlinkisp
    startdedicated
    thoughtlesscracker.ptr.network
    tmdcloud
    totalplay.net
    unil.cloud.switch.ch
    vps
  ].freeze

  FILTERED_ORGANIZATION_KEYWORDS = [
    "12651980 canada inc.",
    "1337 services",
    "31173 services ab",
    "3xk tech",
    "5g network operations pty ltd",
    "advin services",
    "aeza international",
    "akamai",
    "alibaba",
    "alsycon",
    "amazon",
    "angkor data communication",
    "atomic networks",
    "b2 net solutions",
    "bell canada",
    "bharti airtel",
    "biznet networks",
    "bucklog",
    "centrilogic",
    "centurylink communications",
    "cheapy.host",
    "church of cyberology",
    "cisco systems ironport division",
    "cloud hosting solutions",
    "clouvider",
    "cogent communications",
    "comcast cable communications",
    "contabo",
    "cv andhika pratama sanggoro",
    "da international group ltd.",
    "data communication business group",
    "datacamp limited",
    "detai prosperous technologies limited",
    "digi vps",
    "digitalocean",
    "edgoo networks",
    "estnoc oy",
    "facebook, inc.",
    "feo prest srl",
    "fiberstate",
    "flokinet ehf",
    "flyservers",
    "frantech solutions",
    "glesys",
    "globalconnect",
    "godaddy",
    "google",
    "gsl networks pty",
    "h2nexus",
    "h4y technologies",
    "hetzner",
    "host",
    "hydra communications",
    "insidesign",
    "instra corporation",
    "internet vikings",
    "internetdienste",
    "ionos",
    "ip-eend bv",
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
    "naukowa i akademicka siec komputerowa - panstwowy instytut badawczy",
    "netcup",
    "nybula",
    "office national des postes et telecommunications onpt (maroc telecom) / iam",
    "onyphe",
    "oracle corporation",
    "ovh sas",
    "performive",
    "pfcloud",
    "quickpacket",
    "qwantbot",
    "railnet",
    "rcn",
    "redheberg",
    "scloud pte",
    "serverio technologijos mb",
    "slobozhenyuk",
    "smartnet limited",
    "space exploration technologies corporation",
    "square net",
    "sunucun bilgi iletisim teknolojileri ve ticaret limited sirketi",
    "techoff srv limited",
    "telia eesti",
    "the constant company",
    "total play telecomunicaciones sa de cv",
    "truenet communication co",
    "ucloud",
    "uhq services llc",
    "uk-2 limited",
    "velia.net",
    "widya intersat nusantara",
    "wiit",
    "windstream communications",
    "xneelo",
    "xstream srl"
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
