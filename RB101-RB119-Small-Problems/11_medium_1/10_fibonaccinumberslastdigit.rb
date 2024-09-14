def fibonacci_last(number)
  final_nums = [0, 1]

  2.upto(60) do
    final_nums << (final_nums[-1] + final_nums[-2]) % 10
  end

  final_nums[number % 60]
end

p fibonacci_last(15) == 0        # -> 0  (the 15th Fibonacci number is 610)
p fibonacci_last(20) == 5        # -> 5 (the 20th Fibonacci number is 6765)
p fibonacci_last(100) == 5       # -> 5 (the 100th Fibonacci number is 354224848179261915075)
p fibonacci_last(100_001) == 1   # -> 1 (this is a 20899 digit number)
p fibonacci_last(1_000_007) == 3 # -> 3 (this is a 208989 digit number)
p fibonacci_last(123456789) == 4 # -> 4
