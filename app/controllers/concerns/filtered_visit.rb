module FilteredVisit
  extend ActiveSupport::Concern

  private

  def filter_visits
    Ahoy::Visit.all.reject do |visit|
      bot_visit?(visit) || ignored_country?(visit.country)
    end
  end

  def bot_visit?(visit)
    user_agent = visit.user_agent.to_s.downcase
    hostname = visit.platform.to_s.downcase
    organization = visit.utm_campaign.to_s.downcase
    browser = Browser.new(user_agent)

    browser.bot? ||
    user_agent.include?("http") ||
    hostname.include?("amazon") ||
    organization.include?("digitalocean")
  end

  IGNORED_COUNTRIES = %w[
    CA
    FI
    IN
    NL
    RO
    RU
    SG
    US
  ]

  def ignored_country?(country)
    IGNORED_COUNTRIES.include?(country)
  end
end
