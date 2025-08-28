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

    if @upcoming_shows.any? { |show| show[:date].cweek == Date.today.cweek && show[:date].cwyear == Date.today.cwyear }
      notify(:info, t("notification.upcoming_show"))
    end
  end
end
