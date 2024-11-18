class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

	before_action :set_locale
	before_action :set_data

	private

	def set_locale
		I18n.locale = params[:locale] || I18n.default_locale
	end

	@@data = YAML.load_file(Rails.root.join("config/data.yml")).deep_symbolize_keys

	def set_data
		@footer_logo = @@data.dig(*%i[media templates footer_logo])
	end
end
