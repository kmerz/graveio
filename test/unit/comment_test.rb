require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "default is set to Anonymus" do
    c = Comment.new
    assert_equal "Anonymus", c.commenter
  end
end
