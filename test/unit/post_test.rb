require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "creation of post" do
    assert p = Post.new
    assert_equal false, p.valid?, "should not be valid"
    p.content = "asdf"
    assert_equal true, p.valid?, "should be valid"
    assert_nothing_raised {p.save!}
  end

  test "feed" do
    date = Time.now + 1
    assert_nothing_raised{ Post.feed(date) }
    first_posts = Post.feed(date)
    assert_equal 20, first_posts.size
    date = first_posts.to_a.last.created_at
    second_posts = Post.feed(date)
    assert_not_equal first_posts, second_posts
  end
end
