def triangle(num)
  space = num - 1
  asterisk = 1
  num.times do |_i|
    puts (" " * space) + ("*" * asterisk)
    space -= 1
    asterisk += 1
  end
end

triangle(5)
triangle(9)

# Further exploration

def inverted_triangle(num)
  num.downto(1) do
    puts "*" * num
    num -= 1
  end
end

inverted_triangle(5)
inverted_triangle(9)
