module FilteredVisit
  extend ActiveSupport::Concern

  private

  def filter_visits
    Ahoy::Visit.all.reject do |visit|
      bot_visit?(visit) || blocked_country?(visit.country)
    end
  end

  def bot_visit?(visit)
    user_agent = visit.user_agent.to_s.downcase
    browser = Browser.new(user_agent)
    browser.bot? || user_agent.include?("headless") || visit.ip == "::1"
  end

  BLOCKED_COUNTRIES = %w[
    CA
    IN
    IR
    NL
    RO
    RU
    SG
    US
  ]

  def blocked_country?(country)
    BLOCKED_COUNTRIES.include?(country)
  end
end
