# Write a method that takes an Array as an argument # returns two Arrays (as a pair of nested Arrays)
# containing the first half and second half of the original Array, respectively.
# If the original array contains an odd number of elements, the middle element should be placed in the first half Array.

def halvsies(arr)
  mid = (arr.size / 2.0).round
  [arr[0...mid], arr[mid..-1]]
end

p halvsies([1, 2, 3, 4]) == [[1, 2], [3, 4]] # true
p halvsies([1, 2, 3, 4, 1]) == [[1, 2, 3], [4, 1]] # true
p halvsies([1, 5, 2, 4, 3]) == [[1, 5, 2], [4, 3]] # true
p halvsies([5]) == [[5], []] # true
p halvsies([]) == [[], []] # true
