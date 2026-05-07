require "minitest/autorun"

class TestValue < Minitest::Test
  def test_downcase_value
    value = "XYZ"
    assert_equal "xyz", value.downcase, "Value is not xyz!"
    # or
    # assert value.downcase == "xyz", "Value is not xyz!"
  end
end
