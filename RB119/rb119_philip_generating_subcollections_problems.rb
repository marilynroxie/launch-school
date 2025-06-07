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

p sequential_pairs(sample) == [[1, 2], [2, 3], [3, 4], [4, 5]]

# Problem 2

# Group the array into sequential pairs. "Consume" elements - if they're part of one pair, they can't be part of any other

# Understanding the Problem

# inputs: array
# outputs: array of subarrays / nested array
# explicit: each number can only be represented once
# implicit: can't go out of bounds (if last element is 5, you would not include 6)

# Data structure
# Array of subarrays

# Algorithm

# Initialize array of subarrays
# Iterate over array argument
# Add [arr[idx], arr[idx + 1]] unless subarrays.flatten.include?(arr[idx]) or arr[idx].nil?
# Return subarrays

# Code

sample = [1, 2, 3, 4, 5]

def group_sequential_pairs(arr)
  subarrays = []

  (0..arr.length).each do |idx|
    next if subarrays.flatten.include?(arr[idx]) || arr[idx].nil?
    arr[idx + 1].nil? ? subarrays << [arr[idx]] : subarrays << [arr[idx], arr[idx + 1]]
  end

  subarrays
end

p group_sequential_pairs(sample) == [[1, 2], [3, 4], [5]]

# Problem 3

# Group the array into concentric pairs - the first and last elements, then the second and second-last, etc. Consume elements as before.

# Understanding the Problem

# inputs: array
# outputs: array of subarrays / nested array
# explicit: each element must only appear once (consumed)
# implicit: don't go out of bounds (no nil)

# Data structure
# Array to include subarrays

# Algorithm

# Initialize array to store subarrays
# Duplicate array
# Until the duplicate array is empty
# If new_arr.size == 1 subarrays << [new_arr.pop]
# Otherwise subarrays << [new_arr.shift, new_arr.pop]
# Return array of subarrays

# Code

sample = [1, 2, 3, 4, 5]

def concentric_pairs(arr)
  subarrays = []
  new_arr = arr.dup

  until new_arr.empty?
    if new_arr.size == 1
      subarrays << [new_arr.pop]
    else
      subarrays << [new_arr.shift, new_arr.pop]
    end
  end

  subarrays
end

p concentric_pairs(sample) == [[1, 5], [2, 4], [3]]

# Problem 4

# Generate all possible pairs of the array

# Understanding the Problem

# inputs: array
# outputs: array of subarrays
# explicit: repeating numbers are fine and expected except for the number and itself (e.g. [1, 1])
# implicit: don't go out of bounds

# Data structure
# Array of subarrays

# Algorithm

# Initialize empty array to store subarrays in
# Iterate through nested each_with_index to identify first and second elements
# Add [element1, element2] to subarray if their indices are not the same
# Return array of subarrays

# Code

def all_pairs(arr)
  subarrays = []

  arr.each_with_index do |i1, idx1|
    arr.each_with_index do |i2, idx2|
      if idx1 != idx2
        subarrays << [i1, i2]
      end
    end
  end
  subarrays
end

sample = [1, 2, 3, 4, 5]

p all_pairs(sample) == [[1, 2], [1, 3], [1, 4], [1, 5],
                        [2, 1], [2, 3], [2, 4], [2, 5],
                        [3, 1], [3, 2], [3, 4], [3, 5],
                        [4, 1], [4, 2], [4, 3], [4, 5],
                        [5, 1], [5, 2], [5, 3], [5, 4]]

# Problem 5

# Generate all possible pairs of the array, but only in ascending order (that is, the element earlier in the argued array should come first in its subarray)

# Understanding the Problem

# inputs: array
# outputs: array of subarrays / nested array
# explicit: ascending order required (e.g. [2, 1] is unacceptable)
# implicit: don't go out of bounds

# Data structure
# nested array

# Algorithm

# Initialize empty array to store subarrays
# Iterate over array argument with nested each_with_index loop
# Add [element1, element2] to subarray only if idx2 > idx 1
# Return subarray

# Code

def all_ascending_pairs(arr)
  subarray = []

  arr.each_with_index do |i1, idx1|
    arr.each_with_index do |i2, idx2|
      if idx2 > idx1
        subarray << [i1, i2]
      end
    end
  end

  subarray
end

sample = [1, 2, 3, 4, 5]

p all_ascending_pairs(sample) == [[1, 2], [1, 3], [1, 4], [1, 5],
                                  [2, 3], [2, 4], [2, 5],
                                  [3, 4], [3, 5],
                                  [4, 5]]

# Problem 6

# Generate the cross product of an array with itself. This is similar to pairs, but we include the pair of the element with itself.

# Understanding the Problem

# inputs: array
# outputs: array of subarrays
# explicit: element with itself in the pair is fine e.g. [1, 1]
# implicit: don't go out of bounds

# Data structure
# array of subarrays

# Algorithm
# Initialize array of subarrays
# Nested loop of arr.each to capture element1 and element2 (indices are not needed here)
# Add all [element1, element2] pairs to subarray since duplicates of numbers are fine
# Return array of subarrays

# Code

def cross_product(arr)
  subarrays = []

  arr.each do |i1|
    arr.each do |i2|
      subarrays << [i1, i2]
    end
  end

  subarrays
end

sample = [1, 2, 3, 4, 5]

p cross_product(sample) == [[1, 1], [1, 2], [1, 3], [1, 4], [1, 5],
                            [2, 1], [2, 2], [2, 3], [2, 4], [2, 5],
                            [3, 1], [3, 2], [3, 3], [3, 4], [3, 5],
                            [4, 1], [4, 2], [4, 3], [4, 4], [4, 5],
                            [5, 1], [5, 2], [5, 3], [5, 4], [5, 5]]

# Problem 7

# Generate all consecutive subarrays beginning from the first array element

# Understanding the Problem

# inputs: array
# outputs: array of subarrays / nested array
# explicit: order from smallest to largest in groups until array is exhausted
# implicit: no going out of bounds, smallest subarray has a size of one element

# Data Structure
# Array of subarrays

# Algorithm

# Initialize empty array to store subarrays
# From the range 0...arr.size, iterate over the indices
# Slice arr[0..i] and add these slices to subarrays
# Return te array of subarrays

# Code

def first_subarrays(arr)
  subarrays = []

  (0...arr.size).each do |idx|
    subarrays << arr[0..idx]
  end

  subarrays
end

sample = [1, 2, 3, 4, 5]

p first_subarrays(sample) == [[1], [1, 2], [1, 2, 3], [1, 2, 3, 4], [1, 2, 3, 4, 5]]

# Problem 8

# Generate all consecutive subarrays ending with the last array element

# Understanding the Problem

# inputs: array
# outputs: array of subarrays
# explicit: in consecutive order from largest to smallest slices of the original array
# implicit: don't go out of bounds

# Data structure
# Array of subarrays

# Algorithm

# Initialize an empty array to store subarrays
# For the range 0...arr.size, iterate through the elements
# Add the sliced subarrays << arr[idx..-1]
# Return array of subarrays

# Code

def last_subarrays(arr)
  subarrays = []

  (0...arr.size).each do |idx|
    subarrays << arr[idx..-1]
  end

  subarrays
end

p last_subarrays(sample) == [[1, 2, 3, 4, 5], [2, 3, 4, 5], [3, 4, 5], [4, 5], [5]]

# Problem 9

# Generate all consecutive subarrays of the array

# Understanding the Problem

# inputs: array
# outputs: array of subarrays
# explicit: subarrays are smallest to largest
# implicit: can't go out of bounds

# Data structure
# Array to store subarrays

# Algorithm

# Initialize empty array for storing subarrays
# Iterate through argument array
# For each starting index in 0...arr.size (outer loop) add arr[start_idx..end_idx]] (inner loop) to subarrays
# Return sorted subarrays

# Code

def consecutive_subarrays(arr)
  subarrays = []

  (0...arr.size).each do |start_idx|
    (start_idx...arr.size).each do |end_idx|
      subarrays << arr[start_idx..end_idx]
    end
  end

  subarrays.sort
end

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
