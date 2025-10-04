require "rails_helper"

RSpec.describe "Notifications", type: :request do
  it "sets a flash notification when loading path" do
    # Disable 1/4 notification display chance
    allow_any_instance_of(ApplicationController)
      .to receive(:rand).with(4).and_return(0)

    get root_path

    expect(flash[:info]).to include(:message, :title)
    expect(flash[:info][:title]).to eq(I18n.t("header.visitor_count").capitalize)
    expect(flash[:info][:message]).to include(I18n.t("notification.total_visitors"))
  end
end
