require "test_helper"

class MusicControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get music_url
    assert_response :success
  end
end
