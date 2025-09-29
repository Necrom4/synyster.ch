require "rails_helper"

RSpec.describe Ahoy::Visit, type: :model do
  describe ".filtered" do
    it "includes valid visit" do
      valid_visit = create(:ahoy_visit)
      expect(Ahoy::Visit.filtered).to include(valid_visit)
    end

    it "excludes invalid visit" do
      bot_visit = create(:ahoy_visit, :bot_user_agent)
      invalid_ip_visit = create(:ahoy_visit, :filtered_ip)
      invalid_country_visit = create(:ahoy_visit, :filtered_country)
      invalid_landing_page_visit = create(:ahoy_visit, :filtered_landing_page)
      invalid_hostname_visit = create(:ahoy_visit, :filtered_hostname)
      invalid_user_agent_visit = create(:ahoy_visit, :filtered_user_agent)
      invalid_org_name_visit = create(:ahoy_visit, :filtered_organization_name)
      expect(Ahoy::Visit.filtered).not_to include(bot_visit)
      expect(Ahoy::Visit.filtered).not_to include(invalid_ip_visit)
      expect(Ahoy::Visit.filtered).not_to include(invalid_country_visit)
      expect(Ahoy::Visit.filtered).not_to include(invalid_landing_page_visit)
      expect(Ahoy::Visit.filtered).not_to include(invalid_hostname_visit)
      expect(Ahoy::Visit.filtered).not_to include(invalid_user_agent_visit)
      expect(Ahoy::Visit.filtered).not_to include(invalid_org_name_visit)
    end
  end
end
