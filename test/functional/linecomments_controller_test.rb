require 'test_helper'

class LinecommentsControllerTest < ActionController::TestCase
  def setup
    @post = Post.first
  end

  test "should get new" do
    get :new, :post_id => @post.id, :line => 1

    assert_response :success
    assert_not_nil assigns(:post)
    assert_not_nil assigns(:line)
    assert_template("linecomments/_new")
  end

  test "should create linecomment" do
    assert_difference('Linecomment.count') do
      post :create, post_id: @post.id,
        linecomment: {
          body: "Franz",
          line: 1,
          post_id: @post.id,
        }, :format => :json
    end

    assert_equal "saved comment", json_response["notice"]
    assert_response :success
  end

  test "should not create linecomment when error occured" do
    assert_no_difference('Linecomment.count') do
      post :create, post_id: @post.id,
        linecomment: {
          line: 1,
          post_id: @post.id,
        }, :format => :json
    end

    assert_equal ["Body can't be blank"], json_response["error"]
    assert_response :success
  end
end
