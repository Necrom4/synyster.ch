class AboutController < ApplicationController
  def index
		@band_members = @@data.dig(*%i[band_members])
  end
end
