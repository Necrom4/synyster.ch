require "rails_helper"

RSpec.describe MusicController, type: :request do
  describe "GET /music" do
    it "returns success" do
      get "/music"
      expect(response).to have_http_status(:success)
    end
  end
end
