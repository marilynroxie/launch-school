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

def string_to_signed_integer(str, numbers)
  result = str.delete('+').chars.reduce(0) do |integer, char|
    if char == '-'
      -integer
    else
      integer * 10 + numbers[char]
    end
  end

  str.start_with?('-') ? -result : result
end

p string_to_signed_integer('4321', numbers) == 4321
p string_to_signed_integer('-570', numbers) == -570
p string_to_signed_integer('+100', numbers) == 100
