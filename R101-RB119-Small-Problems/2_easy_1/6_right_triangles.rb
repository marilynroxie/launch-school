def triangle(n)
  space = n - 1
  asterisk = 1
  n.times do |i|
    puts (" " * space) + ("*" * asterisk)
    space -= 1
    asterisk += 1
  end
end

triangle(5)
triangle(9)

# Further exploration

def inverted_triangle(n)
  n.downto(1) do
    puts "*" * n
    n -= 1
  end
end

inverted_triangle(5)
inverted_triangle(9)
