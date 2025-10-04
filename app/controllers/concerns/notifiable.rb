module Notifiable
  extend ActiveSupport::Concern

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
