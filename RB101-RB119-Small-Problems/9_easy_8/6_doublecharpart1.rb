def repeater(str)
  str = str.split("")
  str.each { |char| char.concat(char) }.join("")
end

p repeater('Hello') == "HHeelllloo"
p repeater("Good job!") == "GGoooodd  jjoobb!!"
p repeater('') == ''
