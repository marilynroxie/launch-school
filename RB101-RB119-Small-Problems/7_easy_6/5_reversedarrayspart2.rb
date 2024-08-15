def reverse(arr)
  new_arr = []
  i = arr.length - 1

  while i >= 0
    new_arr << arr[i]
    i -= 1
  end

  new_arr
end

p reverse([1, 2, 3, 4]) == [4, 3, 2, 1]         # => true
p reverse([1, 2, 3, 4, 1]) == [1, 4, 3, 2, 1]   # => true
p reverse(%w(a b e d c)) == %w(c d e b a)       # => true
p reverse(['abc']) == ['abc']                   # => true
p reverse([]) == []                             # => true

list = [1, 3, 2]                                # => [1, 3, 2]
new_list = reverse(list)                        # => [2, 3, 1]
p list.object_id != new_list.object_id          # => true
p list == [1, 3, 2]                             # => true
p new_list == [2, 3, 1]                         # => true
