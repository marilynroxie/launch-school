require "minitest/autorun"

class NoExperienceError < StandardError; end

class Employee
  attr_reader :experience, :hired

  def initialize(experience)
    @experience = experience
    @hired = false
  end

  def hire
    if experience < 3
      raise NoExperienceError
    else
      @hired = true
    end
  end
end

class TestEmployee < Minitest::Test
  def test_hire_exception_with_low_experience
    employee = Employee.new(2)
    assert_raises NoExperienceError do
      employee.hire
    end
  end
end
