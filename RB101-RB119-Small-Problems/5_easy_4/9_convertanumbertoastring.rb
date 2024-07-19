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

p integer_to_string(4321, numbers) == '4321'
p integer_to_string(0, numbers) == '0'
p integer_to_string(5000, numbers) == '5000'
