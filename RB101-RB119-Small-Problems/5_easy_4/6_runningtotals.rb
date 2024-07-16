def running_total(arr)
  count = 0
  arr.map { |i| count += i }
end

p running_total([2, 5, 13]) == [2, 7, 20]
p running_total([14, 11, 7, 15, 20]) == [14, 25, 32, 47, 67]
p running_total([3]) == [3]
p running_total([]) == []

# Further exploration:

def running_total(arr)
  count = 0
  arr.each_with_object([]) { |num, sum| sum << (sum.last || count) + num }
end
