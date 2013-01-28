require 'test_helper'

class LikedislikeTest < ActiveSupport::TestCase
  test "a like has a post" do
    assert_nothing_raised { l = Likedislike.new }
    assert_not_nil l = Likedislike.new
    assert_nothing_raised { l.post }
  end
end
