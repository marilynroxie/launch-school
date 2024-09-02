def average(arr)
  sum = 0
  arr.each do |element|
    sum += element
  end
  sum / arr.size
end

p average([1, 6]) == 3 # integer division: (1 + 6) / 2 -> 3
p average([1, 5, 87, 45, 8, 8]) == 25
p average([9, 47, 23, 95, 16, 52]) == 40
