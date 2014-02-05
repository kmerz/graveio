require 'test_helper'

class PostTest < ActiveSupport::TestCase

  setup do
    @post = posts(:one)
  end

  test "should be tagged" do
    assert_not_nil(@post.tags)
  end

  test "should create new tag if not existant" do
    assert_difference('Tag.count','PostTag.count',@post.tags.count) do
      @post.link_tag("new_tag")
    end
  end

  test "should use existant tag" do
    assert_difference('PostTag.count', @post.tags.count) do
      assert_no_difference('Tag.count') do
        @post.link_tag(tags(:two).name)
      end
    end
  end

end
