require "rails_helper"

RSpec.describe "AdminController", type: :request do
  before { ENV["ADMIN_KEY"] = "1234" }

  let(:path) { "/admin/db_tables_snapshot" }
  let(:json) { JSON.parse(response.body) }

  context "with correct key" do
    it "renders JSON snapshot" do
      get path, params: {key: "1234"}

      expect(response).to have_http_status(:ok)
      expect(json.keys).to include("Filtered Visits", "Filtered Events")
    end
  end

  context "with wrong key" do
    it "denies access" do
      get path, params: {key: "wrong"}

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to eq("Access denied")
    end
  end
end
