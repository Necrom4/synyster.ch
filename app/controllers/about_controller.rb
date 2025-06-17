class AboutController < ApplicationController
  def index
    @band_members = @@data.dig(*%i[media about band_members])
    @logo = @@data.dig(*%i[media about logo])
    @background = @@data.dig(*%i[media about background])
    @band = @@data.dig(*%i[media about band])
  end
end
