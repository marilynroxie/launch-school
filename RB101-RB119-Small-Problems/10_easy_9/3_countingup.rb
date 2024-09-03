def sequence(num)
  arr = [1]
  return arr if num == 1
  count = arr[0]
  loop do
    count += 1
    arr << count
    break if arr.size == num
  end
  arr
end

p sequence(5) == [1, 2, 3, 4, 5]
p sequence(3) == [1, 2, 3]
p sequence(1) == [1]
