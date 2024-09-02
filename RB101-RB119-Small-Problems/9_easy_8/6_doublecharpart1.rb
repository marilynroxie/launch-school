def repeater(str)
  str.split("").each do |char|
    char.concat(char)
  end.join("")
end

p repeater('Hello') == "HHeelllloo"
p repeater("Good job!") == "GGoooodd  jjoobb!!"
p repeater('') == ''
