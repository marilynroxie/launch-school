def fibonacci(number)
  first, last = 1, 1

  (number - 2).times do
    first, last = last, first + last
  end

  last
end

p fibonacci(20) == 6765
p fibonacci(100) == 354224848179261915075
p fibonacci(100_001) # => 4202692702.....8285979669707537501
