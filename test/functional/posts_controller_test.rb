require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:one)
    sign_in users(:kmerz)
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

  test "should create post with author" do
    assert_difference('Post.count') do
      post :create, post: {
        content: @post.content,
        title: @post.title,
        author: @post.author
      }
    end

    assert_redirected_to post_path(assigns(:post))
  end

  test "should create post with tags" do
    assert_difference('Post.count') do
      assert_difference('Tag.count', 2) do
        assert_difference('PostTag.count', 3) do
          post :create, post: {
            content: @post.content,
            title: @post.title,
            input_tags: "new-tag-2,new-tag,#{tags(:two).name}"
          }
        end
      end
    end

    assert_redirected_to post_path(assigns(:post))
  end

  test "should show post" do
    get :show, id: @post
    assert_response :success
    assert_template(:show)
  end

  test "should show raw post content" do
    get :show, id: @post, :format => :text
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @post
    assert_response :success
  end

  test "should just update the post" do
    put :update, id: @post, post: { content: @post.content, title: @post.title }
    assert_redirected_to post_path(assigns(:post))
    assert_equal assigns(:post).id, @post.id
    assert_nil assigns(:post).parent_id
  end

  test "should update post with a new post and old post as parent" do
    put :update, id: @post, post: { content: @post.content + "new",
      title: @post.title }
    assert_redirected_to post_path(assigns(:post))
    assert_not_equal assigns(:post).id, @post.id
    assert_equal assigns(:post).parent_id, @post.id
    @post.reload
    assert_equal false, @post.newest
    assert_equal true, assigns(:post).newest
  end

  test "should create post json" do
    assert_difference('Post.count') do
      post :create, post: { content: @post.content,
        api_key: users(:apikeyuser1).apikey.key },
        :format => :json
    end

    assert_response :success
  end

  test "should update tags" do
    # replace tag "ruby" through "rails". Both tags already exist.
    assert_difference('Tag.count', 0) do
      # "ruby" was already mapped to @post, so replace with "rails"
      assert_difference('PostTag.count', 0) do
        put :update, id: @post, post: {
          content: @post.content,
          title: @post.title,
          input_tags: "rails"
        }
      end
    end

    assert_redirected_to post_path(assigns(:post))
  end

  test "should destroy post json" do
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post, :format => :json
    end

    assert_response :success
  end

  test "should destroy post" do
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end

    assert_response :redirect
  end

  test "should delviver the help page" do
    get :help
    assert_response :success
    assert_not_nil assigns(:server_ip)
    assert_not_nil assigns(:server_port)
    assert_template(:help)
  end

  test "should search for posts" do
    get :search, :query => "bla.rb"
    assert_response :success
    assert_not_nil assigns(:posts)
    assert_template(:search)
  end

  test "should show diff for post with parent" do
    get :diff, :id => 106
    assert_response :success
    assert_not_nil(:post)
    assert_template(:diff)
  end

  test "should upload file from form" do
    test_image = "test/fixtures/test.txt"
    file = Rack::Test::UploadedFile.new(test_image, "text/plain")

    assert_difference('Post.count') do
      post :create, post: {
        content: @post.content,
        title: @post.title,
        author: @post.author,
        upload_file: file
      }
    end

  end

end
