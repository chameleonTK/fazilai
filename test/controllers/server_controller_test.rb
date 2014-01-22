require 'test_helper'

class ServerControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get chdir" do
    get :chdir
    assert_response :success
  end

end
