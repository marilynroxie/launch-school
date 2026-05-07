require "minitest/autorun"

class TestNumeric < Minitest::Test
  def test_value_is_instance_of_numeric
    value = 42
    assert_instance_of Integer, value
  end
end
