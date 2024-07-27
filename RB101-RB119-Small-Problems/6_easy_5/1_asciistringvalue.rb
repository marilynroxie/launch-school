def ascii_value(str)
  str.split("").inject(0) { |sum, x| sum + x.ord }
end

p ascii_value('Four score') == 984
p ascii_value('Launch School') == 1251
p ascii_value('a') == 97
p ascii_value('') == 0

# Further exploration

# The mystery method is .chr for a single character; for a longer string, it will return the ascii value of the first character.

char.ord.chr == char
