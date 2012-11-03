require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
    assert_template(:index)
  end

  test "should get index for js batch wise" do
    get :index, :format => "js"
    assert_response :success
    assert_not_nil assigns(:posts)
    assert_template(:index)

    first_batch = assigns(:posts)
    assert_equal 20, first_batch.size
    date = first_batch.to_a.last.created_at.to_s

    get :index, :format => "js", :last => date
    assert_response :success
    assert_not_nil assigns(:posts)
    second_batch = assigns(:posts)
    assert_not_equal first_batch, second_batch
    assert_template(:index)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_template(:new)
  end

  test "should create post" do
    assert_difference('Post.count') do
      post :create, post: { content: @post.content, title: @post.title }
    end

    assert_redirected_to post_path(assigns(:post))
  end

  test "should show post" do
    get :show, id: @post
    assert_response :success
    assert_template(:show)
  end

  test "should get edit" do
    get :edit, id: @post
    assert_response :success
  end

  test "should update post" do
    put :update, id: @post, post: { content: @post.content, title: @post.title }
    assert_redirected_to post_path(assigns(:post))
  end

  test "should destroy post" do
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end

    assert_redirected_to posts_path
  end

end
