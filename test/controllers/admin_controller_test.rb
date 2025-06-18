require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get db_check" do
    get admin_db_check_url
    assert_response :success
  end
end
