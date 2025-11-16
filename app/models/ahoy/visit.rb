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
    "1337 services",
    "3xk tech",
    "advin services",
    "aeza international",
    "akamai",
    "alibaba",
    "amazon",
    "atomic networks",
    "bell canada",
    "bharti airtel",
    "bucklog",
    "centrilogic",
    "cheapy.host",
    "cisco systems ironport division",
    "cloud hosting solutions",
    "clouvider",
    "cogent communications",
    "comcast cable communications",
    "contabo",
    "cv andhika pratama sanggoro",
    "da international group ltd.",
    "datacamp limited",
    "detai prosperous technologies limited",
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
    "total play telecomunicaciones sa de cv",
    "truenet communication co",
    "mevspace",
    "microsoft",
    "milkywan association",
    "musarubra",
    "netcup",
    "nybula",
    "onyphe",
    "oracle corporation",
    "ovh sas",
    "performive",
    "quickpacket",
    "qwantbot",
    "railnet",
    "rcn",
    "redheberg",
    "scloud pte",
    "serverio technologijos mb",
    "smartnet limited",
    "space exploration technologies corporation",
    "sunucun bilgi iletisim teknolojileri ve ticaret limited sirketi",
    "square net",
    "techoff srv limited",
    "the constant company",
    "ucloud",
    "uhq services llc",
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
