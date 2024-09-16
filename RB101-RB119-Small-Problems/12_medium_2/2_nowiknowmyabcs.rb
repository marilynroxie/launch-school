ALPHABET = {
  "B" => "O", "X" => "K", "D" => "Q",
  "C" => "P", "N" => "A", "G" => "T",
  "R" => "E", "F" => "S", "J" => "W",
  "H" => "U", "V" => "I", "L" => "Y", "Z" => "M",
}

def block_word?(str)
  arr = []

  str.upcase.each_char do |char|
    block = ALPHABET[char] || ALPHABET.key(char)

    if arr.include?(char) || (block && arr.include?(block))
      return false
    end
    arr << char
  end
  true
end

p block_word?("BATCH") == true
p block_word?("BUTCH") == false
p block_word?("jest") == true
p block_word?("apples") == false
p block_word?("Baby") == false
