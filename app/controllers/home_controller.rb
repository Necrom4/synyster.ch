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

    ahoy.track "Viewed home"
    visit_count = Ahoy::Visit.count
    base_count = VisitOffset.first&.base_count || 0
    @visit_count = base_count + visit_count
  end
end
