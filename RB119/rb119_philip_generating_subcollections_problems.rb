=begin
Basic nested iteration problems
=end

sample = [1, 2, 3, 4, 5]

# Problem 1

# Generate all sequential pairs of the array

# Understanding the Problem

# inputs: array
# outputs: array of subarrays / nested array
# explicit: will be an array of subarrays representing every sequential number possible until end of array
# implicit: cannot go out of bounds (e.g. no [5, 6] if the last array element in original argument is 5), it is fine for
# array numbers to repeat

# Data structure
# Array to store subarrays

# Algorithm

# Initialize empty array to store subarrays in
# Iterate over 0..arr.length - 2 and add [arr[element], arr[element + 1]] to subarrays array
# Return array of subarray

# Code

def sequential_pairs(arr)
  subarrays = []
  (0..arr.length - 2).each do |idx|
    subarrays << [arr[idx], arr[idx + 1]]
  end
  subarrays
end

p group_sequential_pairs(sample) == [[1, 2], [2, 3], [3, 4], [4, 5]]

# Group the array into sequential pairs. "Consume" elements - if they're part of one pair, they can't be part of any other

p group_sequential_pairs(sample) == [[1, 2], [3, 4], [5]]

# Group the array into concentric pairs - the first and last elements, then the second and second-last, etc. Consume elements as before.

p concentric_pairs(sample) == [[1, 5], [2, 4], [3]]

# Generate all possible pairs of the array

p all_pairs(sample) == [[1, 2], [1, 3], [1, 4], [1, 5],
                        [2, 1], [2, 3], [2, 4], [2, 5],
                        [3, 1], [3, 2], [3, 4], [3, 5],
                        [4, 1], [4, 2], [4, 3], [4, 5],
                        [5, 1], [5, 2], [5, 3], [5, 4]]

# Generate all possible pairs of the array, but only in ascending order (that is, the element earlier in the argued array should come first in its subarray)

p all_ascending_pairs(sample) == [[1, 2], [1, 3], [1, 4], [1, 5],
                                  [2, 3], [2, 4], [2, 5],
                                  [3, 4], [3, 5],
                                  [4, 5]]

# Generate the cross product of an array with itself. This is similar to pairs, but we include the pair of the element with itself.

p cross_product(sample) == [[1, 1], [1, 2], [1, 3], [1, 4], [1, 5],
                            [2, 1], [2, 2], [2, 3], [2, 4], [2, 5],
                            [3, 1], [3, 2], [3, 3], [3, 4], [3, 5],
                            [4, 1], [4, 2], [4, 3], [4, 4], [4, 5],
                            [5, 1], [5, 2], [5, 3], [5, 4], [5, 5]]

# Generate all consecutive subarrays beginning from the first array element
p first_subarrays(sample) == [[1], [1, 2], [1, 2, 3], [1, 2, 3, 4], [1, 2, 3, 4, 5]]

# Generate all consecutive subarrays ending with the last array element
p last_subarrays(sample) == [[1, 2, 3, 4, 5], [2, 3, 4, 5], [3, 4, 5], [4, 5], [5]]

# Generate all consecutive subarrays of the array
p consecutive_subarrays(sample) == [[1], [1, 2], [1, 2, 3], [1, 2, 3, 4], [1, 2, 3, 4, 5],
                                    [2], [2, 3], [2, 3, 4], [2, 3, 4, 5],
                                    [3], [3, 4], [3, 4, 5],
                                    [4], [4, 5],
                                    [5]]

# Generate all subarrays (consecutive or not) from the array where the elements are in ascending order
p ordered_subarrays(sample) == [[1], [1, 2], [1, 2, 3], [1, 2, 3, 4], [1, 2, 3, 4, 5],
                                [1, 2, 3, 5], [1, 2, 4], [1, 2, 4, 5], [1, 2, 5],
                                [1, 3], [1, 3, 4], [1, 3, 4, 5], [1, 3, 5],
                                [1, 4], [1, 4, 5], [1, 5],
                                [2], [2, 3], [2, 3, 4], [2, 3, 5],
                                [2, 4], [2, 4, 5], [2, 5],
                                [3], [3, 4], [3, 4, 5], [3, 5], [4], [4, 5], [5]]

# Generate all permutations of the array - that is, every possible array that can be formed by ordering the elements of the argued array
p permutations(sample) == sample.permutation.to_a # check against the provided Array method

# Generate all subarray permutations of the array - all subarrays, consecutive or not, in any order.
small_sample = [1, 2, 3]
p sub_permutations(small_sample) == [[1], [1, 2], [1, 2, 3], [1, 3], [1, 3, 2],
                                     [2], [2, 1], [2, 1, 3], [2, 3], [2, 3, 1],
                                     [3], [3, 1], [3, 1, 2], [3, 2], [3, 2, 1]]

# Rotate the argued array so that the rows are now columns and vice versa. The object returned by argued_array[x][y] should be the same object returned by rotated_array[y][x]
nested_sample = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
p rotation(nested_sample) == [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
