numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.shift(1)
end

# 1 3 would be output and the return would be [3, 4]. After 1 is printed, it is removed. 2 is therefore removed and the next number is 3. However, because the array now contains two items, covering index 0 and 1, the iteration stops and 4 is not printed.

numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.pop(1)
end

# 1 2 would be output and the return would be [1, 2]. numbers.pop(1) removes 4 from the end of the array, then 3 after 2 is printed. Since the array has been iterated through indexes 0 and 1 and it has two elements in it, iteration stops.

# Both examples demonstrate that iteration is through the original array and not a copy.
