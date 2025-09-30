require "rails_helper"

RSpec.describe DbTablesSnapshot, type: :service do
  describe ".call" do
    let!(:valid_visit) { create(:ahoy_visit) }
    let!(:invalid_visit) { create(:ahoy_visit, :bot_user_agent) }
    let!(:valid_event) { create(:ahoy_event, visit: valid_visit) }

    it "includes filtered visits and events" do
      snapshot = DbTablesSnapshot.call

      expect(snapshot).to have_key("Ahoy::Visit")
      expect(snapshot).to have_key("Filtered Visits")
      expect(snapshot).to have_key("Filtered Events")

      filtered_visits = snapshot["Filtered Visits"]
      expect(filtered_visits).to all(be_a(Ahoy::Visit))
      expect(filtered_visits).to include(valid_visit)
      expect(filtered_visits).not_to include(invalid_visit)

      filtered_events = snapshot["Filtered Events"]
      expect(filtered_events).to include(valid_event)
    end

    it "includes all other tables" do
      snapshot = DbTablesSnapshot.call

      expect(snapshot.keys).to include("Ahoy::Visit", "Ahoy::Event")
    end
  end
end
