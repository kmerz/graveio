require 'test_helper'

class LinecommentTest < ActiveSupport::TestCase
  test "a Linecomment has a post" do
    assert_nothing_raised { l = Linecomment.new }
    assert_not_nil l = Linecomment.new
    assert_nothing_raised { l.post }
  end
end
