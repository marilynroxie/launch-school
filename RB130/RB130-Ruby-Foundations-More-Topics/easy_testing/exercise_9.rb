require "minitest/autorun"

class MyList
  def initialize(*values)
    @values = values
  end

  def process
    self
  end
end

class TestList < Minitest::Test
  def test_process_returns_self
    list = MyList.new
    assert_same list, list.process
  end
end
