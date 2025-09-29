require "rails_helper"

RSpec.describe Ahoy::Visit, type: :model do
  describe ".filtered" do
    it "includes valid visit" do
      valid_visit = create(:ahoy_visit)
      expect(Ahoy::Visit.filtered).to include(valid_visit)
    end

    it "excludes invalid visit" do
      invalid_visit = create(:ahoy_visit, :filtered_country)
      expect(Ahoy::Visit.filtered).not_to include(invalid_visit)
    end
  end
end
