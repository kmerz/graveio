require 'test_helper'

class TagsControllerTest < ActionController::TestCase

  test "should create tag on trailing space" do
    assert_difference('Tag.count') do
      get :index, :q => "test-tag ", :format => :json
    end

    assert_equal "test-tag", json_response[0]["name"]
    assert_response :success
  end

  test "should search for tags" do
    get :index, :q => "r", :format => :json

    assert_equal "ruby-on-rails", json_response[0]["name"]
    assert_equal "rails", json_response[1]["name"]
    assert_equal "ruby", json_response[2]["name"]
    assert_response :success
  end
end
