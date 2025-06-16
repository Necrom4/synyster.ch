class HomeController < ApplicationController
  def index
    @upcoming_shows, @past_shows = @@data.dig(*%i[media posters])
      .map { |show| { **show, date: Date.parse(show[:date]) } }
      .sort_by { |show| show[:date] }
      .partition { |show| show[:date] >= Date.today }
    @past_shows.reverse!

    @videos = @@data.dig(*%i[media videos])
    @pictures = @@data.dig(*%i[media pictures])
    @logo = @@data.dig(*%i[media home logo])
    @background = @@data.dig(*%i[media home background])

    @visit = Visit.first_or_create

    unless cookies[:visited]
      @visit.increment!(:count)
      cookies[:visited] = { value: true, expires: 10.minutes.from_now }
    end
  end
end
