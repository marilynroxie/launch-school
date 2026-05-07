require "minitest/autorun"

class TestValue < Minitest::Test
  def test_value_is_nil
    value = nil
    # assert_equal nil, value
    # Got the following output:
    # DEPRECATED: Use assert_nil if expecting nil from exercise_3.rb:6. This will fail in Minitest 6.
    assert_nil value
  end
end
