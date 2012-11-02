require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "creation of post" do
    assert p = Post.new
    assert_equal false, p.valid?, "should not be valid"
    p.content = "asdf"
    assert_equal true, p.valid?, "should be valid"
    assert_nothing_raised {p.save!}
  end
end
