require 'test_helper'

module PackageTracker
  class TrackingControllerTest < ActionController::TestCase
    test "should get track" do
      get :track
      assert_response :success
    end

  end
end
