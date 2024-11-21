class HomeController < ApplicationController
	def index
		@upcoming_shows = @@data.dig(*%i[media posters]).select { |show| Date.parse(show[:date]) >= Date.today }.sort_by { |show| Date.parse(show[:date]) }
		@past_shows = @@data.dig(*%i[media posters]).select { |show| Date.parse(show[:date]) < Date.today }.sort_by { |show| Date.parse(show[:date]) }.reverse

		@videos = @@data.dig(*%i[media videos])
		@pictures = @@data.dig(*%i[media pictures])
		@logo = @@data.dig(*%i[media home logo])
		@background = @@data.dig(*%i[media home background])
	end
end
