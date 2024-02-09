indentation = 0

loop do
  space = " "
  space = space * indentation
  puts space + "The Flintstones Rock!"
  indentation += 1
  break if indentation == 10
end
