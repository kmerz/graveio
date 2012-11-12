require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "a comment has a post" do
    assert_nothing_raised { c = Comment.new }
    assert_not_nil c = Comment.new
    assert_nothing_raised { c.post }
  end
end
