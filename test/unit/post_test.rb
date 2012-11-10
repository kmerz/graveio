require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "should create a post" do
    assert p = Post.new
    assert_equal false, p.valid?, "should not be valid"
    p.content = "asdf"
    assert_equal true, p.valid?, "should be valid"
    assert_nothing_raised {p.save!}
  end

  test "should return a feed" do
    date = Time.now + 1
    assert_nothing_raised{ Post.feed(date) }
    first_posts = Post.feed(date)
    assert_equal 20, first_posts.size
    date = first_posts.to_a.last.created_at
    second_posts = Post.feed(date)
    assert_not_equal first_posts, second_posts
  end

  test "should serach in posts content and title" do
    assert_nothing_raised { Post.search("asdf") }
    assert result = Post.search("asdf"), "should return any results"
    assert_equal 99, result.size
    assert result = Post.search("asdf asdf_5"), "should return any results"
    assert_equal 11, result.size
    assert result = Post.search("asdf asdf_55"), "should return any results"
    assert_equal 1, result.size
    assert_equal "asdf asdf_55", result.first.content
    assert result = Post.search("bla.rb"), "should return any results"
    assert_equal 1, result.size
    assert_equal "bla.rb", result.first.title
  end

  test "should search for author" do
    assert_not_nil result = Post.search("Franz"), "should return any results"
    assert_equal "Franz Ferdinand", result.first.author
  end

  test "should delete comments when destroying post" do
    assert_not_nil p = Post.find(1)
    assert_not_equal 0, p.comments.size
    comment_id = p.comments.first.id
    assert_not_nil Comment.find_by_id(comment_id)
    assert_nothing_raised { p.destroy }
    assert_nil Comment.find_by_id(comment_id)
  end

  test "should can has an author" do
    assert_not_nil p = Post.find(2)
    assert_nothing_raised { p.author }
    assert_nil p.author
    p.author = "Karl"
    assert_nothing_raised { p.save! }
  end
end
