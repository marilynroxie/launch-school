require "minitest/autorun"

class TestNumeric < Minitest::Test
  def test_value_is_kind_of_numeric
    value = 42.42
    assert_kind_of Numeric, value
  end
end
