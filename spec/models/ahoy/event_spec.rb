require "rails_helper"

RSpec.describe Ahoy::Event, type: :model do
  describe ".filtered" do
    let!(:valid_visit) { create(:ahoy_visit) }
    let!(:invalid_visit) { create(:ahoy_visit, :bot_user_agent) }

    let!(:event_from_valid_visit) { create(:ahoy_event, visit: valid_visit) }
    let!(:event_from_invalid_visit) { create(:ahoy_event, visit: invalid_visit) }

    let!(:visit1_event1) { create(:ahoy_event, visit: valid_visit) }
    let!(:visit1_event2) { create(:ahoy_event, visit: valid_visit) }

    it "includes events whose visits are IN Ahoy::Visit.filtered" do
      expect(Ahoy::Event.filtered).to include(event_from_valid_visit)
    end

    it "excludes events whose visits are NOT filtered and share no visit_id" do
      expect(Ahoy::Event.filtered).not_to include(event_from_invalid_visit)
    end

    it "includes ALL events that share a visit_id" do
      expect(Ahoy::Event.filtered).to include(visit1_event1, visit1_event2)
    end
  end
end
