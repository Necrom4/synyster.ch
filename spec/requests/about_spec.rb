require "rails_helper"

RSpec.describe AboutController, type: :request do
  describe "GET /about" do
    it "returns success" do
      get "/about"
      expect(response).to have_http_status(:success)
    end
  end
end
