require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  setup do
    ENV["ADMIN_KEY"] = "test_secret_key"
  end

  test "should get db_tables_snapshot" do
    get admin_db_tables_snapshot_url(key: "test_secret_key")
    assert_response :success
  end
end
