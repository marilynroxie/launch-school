def merge(arr1, arr2)
  arr3 = []
  arr3 << arr1
  arr3 << arr2
  arr3.flatten!.uniq!
  arr3
end

p merge([1, 3, 5], [3, 6, 9])
p merge([1, 3, 5], [3, 6, 9]) == [1, 3, 5, 6, 9]
