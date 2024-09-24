def sum_square_difference(num)
  count = 0
  arr = []
  loop do
    count += 1
    arr << count
    break if count == num
  end
  (arr.sum) ** 2 - arr.map { |i| i ** 2 }.sum
end

p sum_square_difference(3) == 22
# -> (1 + 2 + 3)**2 - (1**2 + 2**2 + 3**2)
p sum_square_difference(10) == 2640
p sum_square_difference(1) == 0
p sum_square_difference(100) == 25164150
