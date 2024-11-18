class HomeController < ApplicationController
	def index
		@upcoming_shows = @@data.dig(*%i[media posters upcoming_shows])
		@past_shows = @@data.dig(*%i[media posters past_shows])
		@videos = @@data.dig(*%i[media videos])
		@pictures = @@data.dig(*%i[media pictures])
		@logo = @@data.dig(*%i[media home logo])
		@background = @@data.dig(*%i[media home background])
	end
end
