require "minitest/autorun"

class TestList < Minitest::Test
  def test_xyz_in_list
    list = ["abc", "xyz"]
    assert_includes list, "xyz"
    # or
    # assert_equal true, list.include?('xyz')
  end
end
