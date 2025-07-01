class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_locale
  before_action :set_data
  before_action :set_visit_count
  before_action :track_event

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  @@data = YAML.load_file(Rails.root.join("config/data.yml")).deep_symbolize_keys

  def set_data
    @footer_logo = @@data.dig(*%i[media templates footer_logo])
  end

  def set_visit_count
    filtered_visits_count = Ahoy::Visit.all.select do |visit|
      !bot_visit?(visit) && !blocked_country?(visit.country)
    end.size

    base_count = ENV["VISIT_COUNT_BEFORE_RESET"].to_i

    @visit_count = base_count + filtered_visits_count
  end

  def bot_visit?(visit)
    user_agent = visit.user_agent.to_s.downcase
    browser = Browser.new(user_agent)
    browser.bot? || user_agent.include?("headless") || visit.ip == "::1"
  end

  def blocked_country?(country)
    %w[IN RO RU US].include?(country)
  end

  def track_event
    ahoy.track "Viewed #{request.path}"
  end

  def notify(type, message)
    flash[type] = message
  end
end
