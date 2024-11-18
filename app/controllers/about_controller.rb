class AboutController < ApplicationController
  def index
		@band_members = @@data.dig(*%i[media about band_members])
  end
end
