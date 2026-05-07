require "minitest/autorun"

class TestValue < Minitest::Test
  def test_value_is_odd
    value = 3
    assert value.odd?, "Value is not odd!"
  end
end
