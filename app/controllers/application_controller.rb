class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :set_data
  before_action :set_visit_count
  before_action :track_event
  before_action -> do
    if @filtered_visits_count.present? && rand(4).zero?
      notify(:info, "#{@filtered_visits_count} #{t("notification.total_visitors")}", t("header.visitor_count").capitalize)
    end
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  @@data = YAML.load_file(Rails.root.join("config/data.yml")).deep_symbolize_keys

  def set_data
    @footer_logo = @@data.dig(*%i[media templates footer_logo])
  end

  def set_visit_count
    base_count = ENV["VISIT_COUNT_BEFORE_RESET"].to_i

    begin
      @filtered_visits_count = base_count + Ahoy::Visit.filtered.size
    rescue *DB_ERRORS => e
      Rails.logger.warn("Skipped Visit Count due to database error: #{e.class} - #{e.message}")
      @filtered_visits_count = nil
    end
  end

  def track_event
    ahoy.track "Viewed #{request.path}"
  rescue *DB_ERRORS => e
    Rails.logger.warn("Skipped Ahoy Tracking due to database error: #{e.class} - #{e.message}")
  end

  def notify(type, message, title = nil, duration = 5000)
    data = { message: message }

    if title.present?
      data[:title] = title
    else
      data[:title] = I18n.t("notification.types.#{type}", default: type.to_s.humanize)
    end

    data[:duration] = duration if duration.present?

    flash[type] = data
  end
end
