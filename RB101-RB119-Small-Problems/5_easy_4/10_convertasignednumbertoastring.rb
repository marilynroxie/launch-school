numbers = {
  0 => "0",
  1 => "1",
  2 => "2",
  3 => "3",
  4 => "4",
  5 => "5",
  6 => "6",
  7 => "7",
  8 => "8",
  9 => "9"
}

def integer_to_string(integer, numbers)
  digits = []

  loop do
    digits.unshift(numbers[integer % 10])
    integer /= 10
    break if integer == 0
  end

  digits.join
end

def signed_integer_to_string(integer, numbers)
  case integer <=> 0
  when -1 then "-#{integer_to_string(-integer, numbers)}"
  when +1 then "+#{integer_to_string(integer, numbers)}"
  else         integer_to_string(integer, numbers)
  end
end

p signed_integer_to_string(4321, numbers) == '+4321'
p signed_integer_to_string(-123, numbers) == '-123'
p signed_integer_to_string(0, numbers) == '0'

# Further Exploration

def signed_integer_to_string(integer, numbers)
  return '0' if integer == 0
  sign = integer.negative? ? '-' : '+'
  sign + integer_to_string(integer * (integer.negative? ? -1 : 1), numbers)
end



