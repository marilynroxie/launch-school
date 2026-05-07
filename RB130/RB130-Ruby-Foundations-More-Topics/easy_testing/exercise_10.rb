require "minitest/autorun"

class TestList < Minitest::Test
  def test_list_does_not_include_xyz
    list = ["abc", "def"]
    refute_includes list, "xyz"
  end
end
