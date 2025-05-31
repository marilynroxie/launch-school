# Problem 1

# Create a method that takes an array of numbers as an argument. For each number, determine how many numbers in the array are smaller than it, and place the answer in an array. Return the resulting array.

# When counting numbers, only count unique values. That is, if a number occurs multiple times in the array, it should only be counted once.

# Inputs: array of integers
# Outputs: array of integers with each number representing how many numbers are smaller than the original in the same place
# Implicit: no empty arrays, no negative numbers, same size as original array
# Explicit: only count unique values

# Data structure
# array of same size as original

# Algorithm

# Assign a value to a variable representing all unique numbers
# Transform the original array
# Within the block of the transformation, count unique values and compare each to every element in the original array
# Return the transformed array

# Code

def smaller_numbers_than_current(arr)
  unique_values = arr.uniq

  arr.map do |i|
    unique_values.count { |num| num < i }
  end
end

# Examples / test cases

p smaller_numbers_than_current([8, 1, 2, 2, 3]) == [3, 0, 1, 1, 2]

# 8 -> 3 because 1, 2, and 3 are smaller than it, totalling 3
# 1 -> 0 because there are no numbers smaller than it
# 2 -> 1 each time because there is only one number smaller (1)
# 3 -> 2 because there are two numbers smaller than 3 (1, 2)

p smaller_numbers_than_current([7, 7, 7, 7]) == [0, 0, 0, 0]

# 7 -> 0 throughout because there is only one unique number in the array

p smaller_numbers_than_current([6, 5, 4, 8]) == [2, 1, 0, 3]

# 6 -> 2 because 5 and 4 are smaller
# 5 - > 1 because only 4 is smaller
# 4 -> 0 because it is the smallest number
# 8 -> 3 because 6, 5, and 4 are smaller

p smaller_numbers_than_current([1]) == [0]
# 1 -> 0 because it's the only number

my_array = [1, 4, 6, 8, 13, 2, 4, 5, 4]
result = [0, 2, 4, 5, 6, 1, 2, 3, 2]
p smaller_numbers_than_current(my_array) == result

# Problem 2

# Create a method that takes an array of integers as an argument.

# The method should return the minimum sum of 5 consecutive numbers in the array.

# If the array contains fewer than 5 elements, the method should return nil.

# Understanding the Problem

# Inputs: array of integers (could be positive or negative)
# Outputs: nil or integer
# Explicit: return nil if arr.size < 5, returned integer represents minimum sum of 5 cons. numbers in the original array
# Implicit: both negative and positive numbers are included, min sum can be positive or negative, can't go out of bounds when counting

# Examples / test cases:

# Data structure
# Array for storing sums, integer as end result (unless arr.size < 5, in which case nil is returned)

# Algorithm

# Can return nil if arr.size < 5
# Transform from index 0 to arr.size < 5
# Within the method body of map, sum the slice arr[i, 5] (five consecutive elements)
# Call min on the array that map returns (array of sums) to find minimum sum and return it

# Code

def minimum_sum(arr)
  (0..arr.length - 5).map do |i|
    arr[i, 5].sum
  end.min
end

p minimum_sum([1, 2, 3, 4]) == nil

# nil is returned because arr.size < 5

p minimum_sum([1, 2, 3, 4, 5, -5]) == 9

# 9 is returned because 2 + 3 + 4 + 5 + -5 = 9 is the minimum sum

p minimum_sum([1, 2, 3, 4, 5, 6]) == 15

# 15 is returned because 1 + 2 + 3 + 4 + 5 = 15 is the minimum sum

p minimum_sum([55, 2, 6, 5, 1, 2, 9, 3, 5, 100]) == 16
p minimum_sum([-1, -5, -3, 0, -1, 2, -4]) == -10

# Problem 3

# Create a method that takes a string argument and returns a copy of the string with every second character in every third word converted to uppercase. Other characters should remain the same.

# Understanding the Problem

# Inputs: string
# Outputs: string with modified text (every second character in every third word converted to uppercase) of same length
# Explicit: string is same size, every second character in every third word is capitalized
# Implicit: spaces are retained, no punctuation is shown in examples, no non alphabetic or space characters are shown

# Data structure
# Array when splitting string, output will be string however

# Algorithm

# Split string to array of words
# Iterate through array of words
# Target every third word (idx + 1 % 3 == 0), leave other words alone
# Target characters and capitalize every second character (idx + 1 % 2 == 0), leave other characters alone, joining these
# Join modified string and return it

# Code

def to_weird_case(str)
  str = str.split

  str.map.with_index do |word, idx|
    if (idx + 1) % 3 == 0
      word.chars.map.with_index do |char, idx|
        if (idx + 1) % 2 == 0
          char = char.upcase
        else
          char
        end
      end.join
    else
      word
    end
  end.join(" ")
end

# Examples / Test Cases

original = "Lorem Ipsum is simply dummy text of the printing world"
expected = "Lorem Ipsum iS simply dummy tExT of the pRiNtInG world"
# Every third word, every second character: iS, tExT, pRiNtInG
p to_weird_case(original) == expected

original = "It is a long established fact that a reader will be distracted"
expected = "It is a long established fAcT that a rEaDeR will be dIsTrAcTeD"
p to_weird_case(original) == expected

p to_weird_case("aaA bB c") == "aaA bB c"

original = "Mary Poppins' favorite word is supercalifragilisticexpialidocious"
expected = "Mary Poppins' fAvOrItE word is sUpErCaLiFrAgIlIsTiCeXpIaLiDoCiOuS"
p to_weird_case(original) == expected

# Problem 4

# Create a method that takes an array of integers as an argument and returns an array of two numbers that are closest together in value. If there are multiple pairs that are equally close, return the pair that occurs first in the array.

# Understanding the Problem
# Inputs: array of integers
# Outputs: array of integers, two numbers representing those that are closest together in value (absolute diffrence)
# Explicit: return first pair if there are multiple equally close paris
# Implicit: no negative numbers, no empty arrays, no arr.size < 2 implied, no arr.size < 4 shown in examples, does not imply numbers that are actually next to each other, but order is maintained

# Examples / Test Cases

p closest_numbers([5, 25, 15, 11, 20]) == [15, 11]

# 15 - 11 = 4, closest together

p closest_numbers([19, 25, 32, 4, 27, 16]) == [25, 27]

# 27 - 25 = 2, closest together

p closest_numbers([12, 22, 7, 17]) == [12, 7]

# 12 - 7 = 5, closest together

# Data structure
# Array of two integers derived from the original array

# Algorithm
