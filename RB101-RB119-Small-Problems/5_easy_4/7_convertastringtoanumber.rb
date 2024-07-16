numbers = {
  '0' => 0,
  '1' => 1,
  '2' => 2,
  '3' => 3,
  '4' => 4,
  '5' => 5,
  '6' => 6,
  '7' => 7,
  '8' => 8,
  '9' => 9
}

def string_to_integer(str, numbers)
  str.chars.reduce(0) { |integer, char| integer * 10 + numbers[char] }
end

p string_to_integer('4321', numbers) == 4321
p string_to_integer('570', numbers) == 570
