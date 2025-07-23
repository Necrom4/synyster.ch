class ApplicationController < ActionController::Base
  include FilteredTraffic

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
    filtered_visits_count = filter_visits.size

    base_count = ENV["VISIT_COUNT_BEFORE_RESET"].to_i

    @filtered_visits_count = base_count + filtered_visits_count
  end

  def track_event
    ahoy.track "Viewed #{request.path}"
  end

  def notify(type, message)
    flash[type] = message
  end
end
