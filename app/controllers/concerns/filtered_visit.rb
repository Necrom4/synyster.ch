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
    platform = visit.platform.to_s.downcase
    browser = Browser.new(user_agent)
    browser.bot? || user_agent.include?("http") || platform.include?("amazon")
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
