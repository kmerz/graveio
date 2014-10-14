require 'test_helper'

class PostTest < ActiveSupport::TestCase

  setup do
    @post = posts(:one)
  end

  test "should be tagged" do
    assert_not_nil(@post.tags)
  end

  test "should create new tag if not existant" do
    assert_difference('Tag.count', 1) do
      assert_difference('PostTag.count', 1) do
        assert_difference(@post.tags.count, 1) do
          @post.link_tag("very_new_tag")
        end
      end
    end
  end

  test "should use existant tag" do
    assert_difference('PostTag.count', 1) do
      assert_difference(@post.tags.count, 1) do
        assert_difference('Tag.count', 0) do
          @post.link_tag(tags(:two).name)
        end
      end
    end
  end

end
