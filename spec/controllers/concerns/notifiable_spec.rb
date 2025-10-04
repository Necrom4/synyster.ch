require "rails_helper"

RSpec.describe Notifiable, type: :controller do
  controller(ApplicationController) do
    include Notifiable
    def index
      notify(:success, "Hello World", "Greetings", 3000)
      render plain: "OK"
    end
  end

  describe "#notify" do
    it "adds a notification to the flash" do
      get :index
      expect(flash[:success][:message]).to eq("Hello World")
      expect(flash[:success][:title]).to eq("Greetings")
      expect(flash[:success][:duration]).to eq(3000)
    end
  end
end
