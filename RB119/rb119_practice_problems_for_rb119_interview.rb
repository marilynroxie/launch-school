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
# Outputs: array of integers, two numbers representing those that are closest together in value (absolute difference)
# Explicit: return first pair with respect to array order if there are multiple equally close pairs
# Implicit: no negative numbers, no empty arrays, no arr.size < 2 implied, no arr.size < 4 shown in examples

# Data structure
# Array of pairs and returning an array of two integers derived from the original array

# Algorithm
# Create an empty pairs array storing all possible pairs
# Iterate through the input array over elements and indices
# Iterate through the input array again over parameters representing the next number and index that come after the first
# Add pairs of elements to the pairs array if the second index is greater than the first
# Return the minimum absolute value of the first element - the second element

# Code

def closest_numbers(arr)
  pairs = []
  arr.each_with_index do |num1, idx1|
    arr.each_with_index do |num2, idx2|
      pairs << [num1, num2] if idx2 > idx1
    end
  end

  pairs.min_by { |a, b| (a - b).abs }
end

# Examples / Test Cases

p closest_numbers([5, 25, 15, 11, 20]) == [15, 11]

# 15 - 11 = 4, closest together

p closest_numbers([19, 25, 32, 4, 27, 16]) == [25, 27]

# 27 - 25 = 2, closest together

p closest_numbers([12, 22, 7, 17]) == [12, 7]

# 12 - 7 = 5, closest together

# Problem 5

# Create a method that takes a string argument and returns the character that occurs most often in the string. If there are multiple characters with the same greatest frequency, return the one that appears first in the string. When counting characters, consider uppercase and lowercase versions to be the same.

# Understanding the Problem

# input: string
# output: string (one character) representing highest frequency
# explicit: uppercase and lowercase are treated the same, if multiple characters have same frequency return the first one
# implicit: special characters and spaces are present in the string

# Data structure
# output is string, but hash could be used to store frequencies and string can be split into an array

# Algorithm
# Form an array of every possible pair
# Find the minimum absolute value from the pairs, maintaining order from the original array

# Set a frequencies hash to 0
# Split string into array of characters
# Iterate through array and count each character (downcase), adding character as a key and count as a value
# Iterate through frequencies, taking a block parameter of letter and count
# Return the highest count that appears first in the frequencies hash

# Code

def most_common_char(str)
  frequencies = Hash.new(0)

  str.downcase.chars.each do |char|
    frequencies[char] += 1
  end

  frequencies.each do |letter, count|
    return letter if count == frequencies.values.max
  end
end

# Examples / Test Cases

p most_common_char("Hello World") == "l"

# 3 ls = most common

p most_common_char("Mississippi") == "i"

# 4 is = most common

p most_common_char("Happy birthday!") == "h"

# 2 hs = most common

p most_common_char("aaaaaAAAA") == "a"

# all as = most common

my_str = "Peter Piper picked a peck of pickled peppers."
p most_common_char(my_str) == "p"

my_str = "Peter Piper repicked a peck of repickled peppers. He did!"
p most_common_char(my_str) == "e"

# Problem 6

# Create a method that takes a string argument and returns a hash in which the keys represent the lowercase letters in the string, and the values represent how often the corresponding letter occurs in the string.

# Understanding the Problem

# Inputs: string
# Outputs: hash
# Explicit: keys represent lowercase letters, values are the count of the lowercase letters
# Implicit: uppercase letters are ignored, symbols are ignored, spaces are ignored

# Data structure
# hash

# Algorithm

# Set a frequencies hash to 0 to store frequencies of lowercase letters
# Split string into characters and iterate over it
# If char =~ a-z, add as key to the hash and increment their count += 1
# Don't need to deal with characters that are not a-z and those that are uppercase
# Return the hash

# Code

def count_letters(str)
  frequencies = Hash.new(0)

  str.chars.each do |char|
    frequencies[char] += 1 if char =~ /[a-z]/
  end

  frequencies
end

# Examples / Test Castes

expected = { "w" => 1, "o" => 2, "e" => 3, "b" => 1, "g" => 1, "n" => 1 }
p count_letters("woebegone") == expected

expected = { "l" => 1, "o" => 1, "w" => 1, "e" => 4, "r" => 2,
             "c" => 2, "a" => 2, "s" => 2, "u" => 1, "p" => 2 }
p count_letters("lowercase/uppercase") == expected

expected = { "u" => 1, "o" => 1, "i" => 1, "s" => 1 }
p count_letters("W. E. B. Du Bois") == expected

p count_letters("x") == { "x" => 1 }
p count_letters("") == {}
p count_letters("!!!") == {}

# Problem 7

# Create a method that takes an array of integers as an argument and returns the number of identical pairs of integers in that array. For instance, the number of identical pairs in [1, 2, 3, 2, 1] is 2: there are two occurrences each of both 2 and 1.

# If the array is empty or contains exactly one value, return 0.

# If a certain number occurs more than twice, count each complete pair once. For instance, for [1, 1, 1, 1] and [2, 2, 2, 2, 2], the method should return 2. The first array contains two complete pairs while the second has an extra 2 that isn't part of the other two pairs.

# Understanding the Problem

# inputs: array
# outputs: integer (representing count of identical pairs of integers in array)
# explicit requirements: count each pair once if a number occurs > 2 times
# implicit requirements: integer will be from 0 to 1 (no negative numbers, of course), empty array or single element array returns 0

# Array with seven elements that are identical returns three because there are three pairs and the final element is not part of them

# Data structure
# Work with array, return integer representing identical pairs

# Algorithm
# Initialize an empty array for pairs
# Initialize an empty array for used indexes when iterating through the input array
# Iterate through the array with each_with_index and a nested call with each_with_index again
# If the second index is greater than the first, both elements equal each other, and the used indexes array doesn't include the first index, then add [element1, element2] to pairs
# Get the length of the pairs array

# Code

def pairs(arr)
  pairs = []
  used_indices = []

  arr.each_with_index do |element1, idx1|
    arr.each_with_index do |element2, idx2|
      if idx2 > idx1 && element1 == element2 && used_indices.include?(idx1) == false
        pairs << [element1, element2]
        used_indices << idx1
        used_indices << idx2
      end
    end
  end
  pairs.length
end

# Examples / Test Cases

p pairs([3, 1, 4, 5, 9, 2, 6, 5, 3, 5, 8, 9, 7]) == 3

# Returns three because the identical pairs are: [3, 3], [5, 5], and [9, 9] (extra 5 is not counted)

p pairs([2, 7, 1, 8, 2, 8, 1, 8, 2, 8, 4]) == 4

# Returns four because the identical pairs are: [1, 1], [2, 2], [8, 8], and [8, 8]

p pairs([]) == 0

# Empty array returns 0 because there are no pairs

p pairs([23]) == 0

# Array with single integer returns 0 because there are no pairs

p pairs([997, 997]) == 1

# Array with two elements that are identical returns 1 because there is one pair

p pairs([32, 32, 32]) == 1

# Array with three elements that are identical returns 1 because there is one pair and the third is not part of it

p pairs([7, 7, 7, 7, 7, 7, 7]) == 3

# Problem 8

# Create a method that takes a non-empty string as an argument. The string consists entirely of lowercase alphabetic characters. The method should return the length of the longest vowel substring. The vowels of interest are "a", "e", "i", "o", and "u".

# Understanding the Problem

# Inputs: string
# Outputs: integer (representing length of longest vowel substring)
# Explicit requirements: interested in aeiou
# Implicit requirements: length is 0 when no vowels are found, integer can't be < 0, all examples are lowercase so capitalization is not a concern here

# Data structure
# Array for splitting up string, array for storing vowel substrings, integer for final count of longest one

# Algorithm
# Initialize array of vowels
# Split string into array of characters
# Initialize empty array to store vowel substrings
# Iterate through array of original string characters
# Should move through array and check if the range of the beginning to ending character is a vowel;
# Build array of vowel substrings
# Check if substrings array is empty; return 0 if so, otherwise find the max length of substring in substrings array and return the count of chars

# Code

def longest_vowel_substring(str)
  vowels = %w(a e i o u)
  str = str.chars
  substrings = []

  0.upto(str.length - 1) do |start|
    start.upto(str.length - 1) do |ending|
      substrings << str[start..ending] if (str[start..ending]).all? { |char| vowels.include?(char) }
    end
  end

  substrings.empty? ? 0 : substrings.max_by { |x| x.length }.count
end

# Examples / test cases

p longest_vowel_substring("cwm") == 0

# No vowels found

p longest_vowel_substring("many") == 1

# 1 substring found, simply "a"

p longest_vowel_substring("launchschoolstudents") == 2

# 2 substrings found of the same longest length: "au", "oo"

p longest_vowel_substring("eau") == 3

# "eau" is the longest (three characters)

p longest_vowel_substring("beauteous") == 3

# "eau" and "eou" are equally long (three characters)

p longest_vowel_substring("sequoia") == 4

# "uoia" is the longest (four characters)

p longest_vowel_substring("miaoued") == 5

# "iaoue" is the longest (five characters)

# Problem 9

# Create a method that takes two string arguments and returns the number of times that the second string occurs in the first string. Note that overlapping strings don't count: 'babab' contains 1 instance of 'bab', not 2.

# You may assume that the second argument is never an empty string.

# Understanding the Problem

# Inputs: strings: the second string represents the item we are counting occurrences of in the first
# Outputs: integer representing count of second argument's occurrences
# Implicit: integer will not be negative, first argument can be empty
# Explicit: overlapping strings can't be counted, second argument will never be empty

# Data structure
# Array to add substrings, integer to represent count of occurrences of second argument

# Algorithm

# Initialize variable at 0 to store count of substrings
# Set increment variable to 0 to keep track of position in str1
# While the increment is less than or equal to the length of string 1 minus string 2:
# - if str1[i, str2.length] == str2, increase count by 1
# - increase increment to the length of str2
# - otherwise increment by one
# return count at the end

# Code

def count_substrings(str1, str2)
  count = 0
  i = 0

  while i <= str1.length - str2.length
    if str1[i, str2.length] == str2
      count += 1
      i += str2.length
    else
      i += 1
    end
  end

  count
end

# Examples / Test Cases

p count_substrings("babab", "bab") == 1

# "bab" is found once (overlap doesn't count)

p count_substrings("babab", "ba") == 2

# "ba" is found in two unique places

p count_substrings("babab", "b") == 3

# "b" is found three times

p count_substrings("babab", "x") == 0

# "x" isn't found anywhere

p count_substrings("", "x") == 0

# first argument is empty, so no substrings can be found

p count_substrings("bbbaabbbbaab", "baab") == 2

# "baab" is found twice

p count_substrings("bbbaabbbbaab", "bbaab") == 2

# "bbaab" is found twice

p count_substrings("bbbaabbbbaabb", "bbbaabb") == 1

# "bbbaabb" is found once

# Problem 10

# Create a method that takes a string of digits as an argument and returns the number of even-numbered substrings that can be formed. For example, in the case of '1432', the even-numbered substrings are '14', '1432', '4', '432', '32', and '2', for a total of 6 substrings.

# If a substring occurs more than once, you should count each occurrence as a separate substring.

# Understanding the Problem

# Inputs: String (representing a number, but not given as integer)
# Outputs: Integer (representing count of seven substrings)
# Implicit: No empty strings given as argument, count will never be less than 0
# Explicit: Duplicate substrings are counted

# Data structure
# Array representing string split into elements, then integer representing count

# Algorithm
# Split string into characters
# Initialize an empty array of substrings
# From the start to the end of the array -1 to avoid going out of bounds
# add str[start..ending] if str[ending].to_i.even? to substrings
# count substrings array at the end

# Code

def even_substrings(str)
  str = str.chars
  substrings = []

  0.upto(str.length - 1) do |start|
    start.upto(str.length - 1) do |ending|
      substrings << str[start..ending].join if str[ending].to_i.even?
    end
  end
  substrings.count
end

# Examples / Test Cases

p even_substrings("1432") == 6

# '14', '1432', '4', '432', '32', and '2'

p even_substrings("3145926") == 16

p even_substrings("2718281") == 16

p even_substrings("13579") == 0

# No even numbers = 0

p even_substrings("143232") == 12

# Problem 11

# Create a method that takes a nonempty string as an argument and returns an array consisting of a string and an integer. If we call the string argument s, the string component of the returned array t, and the integer component of the returned array k, then s, t, and k must be related to each other such that s == t * k. The values of t and k should be the shortest possible substring and the largest possible repeat count that satisfies this equation.

# You may assume that the string argument consists entirely of lowercase alphabetic letters.

# Understanding the Problem

# Inputs: string (s)
# Outputs: two element array of shortest substring (string) (t) and largest repeat count (integer) (k); s == t * k
# Explicit: string argument is downcase letters only, string will never be empty
# Implicit: integer will not be negative, nor less than 1 in any examples shown

# Data structures
# Array when working with string, return value will be an array of [k, t]
# representing the shortest substring (t) and repeat count (k) respectively

# Algorithm
# Iterate over possible substrings from 1 to the length of the string
# For every length, get slice of str[0, substring_length]
# return [substring, str.length / substring_length] if str == substring * (str.length / substring_length)
# Return array of [t, k] (which is substring, repeat count)
# Need to work on detailing this more

# Code

def repeated_substring(str)
  (1..str.length).each do |substring_length|
    substring = str[0, substring_length]
    return [substring, str.length / substring_length] if str == substring * (str.length / substring_length)
  end
end

# Examples / Test Cases

p repeated_substring("xyzxyzxyz") == ["xyz", 3]

# xyzxyzxyz is made up of xyz three times

p repeated_substring("xyxy") == ["xy", 2]

# xy is made up of xy two times

p repeated_substring("xyz") == ["xyz", 1]

# xyz is made up of xyz one time

p repeated_substring("aaaaaaaa") == ["a", 8]

# aaaaaaaa is made up of a repeated eight times

p repeated_substring("superduper") == ["superduper", 1]

# "superduper" is made up of "superduper" once

# Problem 12

# Create a method that takes a string as an argument and returns true if the string is a pangram, false if it is not.

# Pangrams are sentences that contain every letter of the alphabet at least once. For example, the sentence "Five quacking zephyrs jolt my wax bed." is a pangram since it uses every letter at least once. Note that case is irrelevant.

# Understanding the Problem

# Inputs: string
# Outputs: boolean true or false
# Explicit: Return true if string contains every letter of the alphabet one or more times; false if not; case does not matter
# Implicit: punctuation and spaces don't matter here

# Data structure
# Array of characters a-z

# Algorithm
# Initialize a variable storing an array of letters "a" to "z"
# Split string into characters
# Select only characters that are included in "a" to "z"; sort only unique elements and compare to original letters array
# Will return true if there is a match and false if not

# Code

def is_pangram(str)
  letters = Array("a".."z")
  str.downcase.chars.select { |x| ("a".."z").include?(x) }.sort.uniq == letters
end

# Examples / test cases

p is_pangram("The quick, brown fox jumps over the lazy dog!") == true
p is_pangram("The slow, brown fox jumps over the lazy dog!") == false
p is_pangram("A wizard's job is to vex chumps quickly in fog.") == true
p is_pangram("A wizard's task is to vex chumps quickly in fog.") == false
p is_pangram("A wizard's job is to vex chumps quickly in golf.") == true

my_str = "Sixty zippers were quickly picked from the woven jute bag."
p is_pangram(my_str) == true

# Problem 13

# Create a method that takes two strings as arguments and returns true if some portion of the characters in the first string can be rearranged to match the characters in the second. Otherwise, the method should return false.

# You may assume that both string arguments only contain lowercase alphabetic characters. Neither string will be empty.

# Understanding the Problem

# inputs: two strings
# outputs: boolean true or false
# implicit:
# - some portion
# - does not need to be all the same letters, there can be leftover letters in the first string
# e.g. p unscramble("ab", "aaa") should not return true as there needs to be three as. it seems to be a requirement that the quantities are also checked
# explicit: lowercase alphabetic characters, not empty

# Data structure
# Arrays for characters, hashes to store frequencies

# Algorithm

# Split both strings into characters
# Create a hash to store frequencies of letters in the first string
# Create a hash to store frequencies of letters in the second string
# Check if all characters in the second string are found in the first at the same or greater frequency; return true if true and false if false

# Code

def unscramble(str1, str2)
  str1 = str1.chars
  str2 = str2.chars

  frequencies1 = Hash.new(0)
  frequencies2 = Hash.new(0)

  str1.each do |char|
    frequencies1[char] += 1
  end

  str2.each do |char|
    frequencies2[char] += 1
  end

  frequencies2.all? { |char, count| frequencies1[char] >= count }
end

# Examples/ Test Cases

p unscramble("ansucchlohlo", "launchschool") == true
# when broken up, each string contains the same exact letters so it's a given that some portion can be rearranged - all of it can!

p unscramble("phyarunstole", "pythonrules") == true

# "pythonrules can be found within the first string"

p unscramble("phyarunstola", "pythonrules") == false

# slight difference from the first that makes this no longer possible

p unscramble("boldface", "coal") == true

# the word coal is found in the word boldface

# Problem 14

# Create a method that takes a single integer argument and returns the sum of all the multiples of 7 or 11 that are less than the argument. If a number is a multiple of both 7 and 11, count it just once.

# For example, the multiples of 7 and 11 that are below 25 are 7, 11, 14, 21, and 22. The sum of these multiples is 75.

# If the argument is negative, return 0.

# Understanding the Problem

# inputs: integer
# outputs: integer representing sums of all multiples of 7 or 11 < argument integer
# implicit: if 0 is an argument, return 0 as well of course
# explicit: count integer once if it is both a multiple of 7 and 11, return 0 if argument is negative

# Data structure
# Arrays to hold multiples

# Algorithm

# Code

# Initialize empty array
# Count 1.upto the argument number - 1
# Check if each count is a multiple of 7 or 11 (== 0); if so, add it to the array
# Sum array of multiples

def seven_eleven(num)
  arr = []

  1.upto(num - 1).each do |i|
    arr << i if (i % 7) == 0 || (i % 11) == 0
  end

  arr.sum
end

# Examples / Test cases

p seven_eleven(10) == 7

p seven_eleven(11) == 7

p seven_eleven(12) == 18

p seven_eleven(25) == 75

p seven_eleven(100) == 1153

p seven_eleven(0) == 0

# returns 0 because there are no multiples

p seven_eleven(-100) == 0

# returns 0 because it is negative

# Problem 15

# Create a method that takes a string argument that consists entirely of numeric digits and computes the greatest product of four consecutive digits in the string. The argument will always have more than 4 digits.

# Understanding the Problem

# inputs: string
# outputs: integer
# implicit: can't go out of bounds when summing of course, must convert string representing number to an integer
# explicit: always has more than four digits

# Data structure
# array when splitting up string into characters, then integers when summing

# Algorithm

# Split string into characters and convert them all to integers
# Initialize array to store products
# Iterate through 0.upto(arr.size -4) to avoid going out of bounds
# Add all products idx..idx + 3 to array
# Return maximum product

# Code

def greatest_product(str)
  arr = str.chars.map(&:to_i)
  products = []

  0.upto(arr.size - 4) do |idx|
    products << arr[idx..idx + 3].inject(:*)
  end

  products.max
end

# Examples / Test Cases

p greatest_product("23456") == 360      # 3 * 4 * 5 * 6
p greatest_product("3145926") == 540    # 5 * 9 * 2 * 6
p greatest_product("1828172") == 128    # 1 * 8 * 2 * 8
p greatest_product("123987654") == 3024 # 9 * 8 * 7 * 6

# Problem 16

# Create a method that returns the count of distinct case-insensitive alphabetic characters and numeric digits that occur more than once in the input string. You may assume that the input string contains only alphanumeric characters.

# Understanding the Problem

# inputs: string
# outputs: integer (representing counts of characters that occur more than once)
# explicit: case doesn't matter, alphanumeric characters only, distinct letters occurring more than once counted and returned
# implicit: no empty strings

# Data structure
# Array to store characters that appear more than once

# Algorithm

# Split string into array of downcase characters
# Initialize empty array to store characters that appear more than once
# Iterate over array of strings and select only the ones that appear more than once
# Add these to the array
# Return count of unique items in array

# Code

def distinct_multiples(str)
  arr = []
  str = str.downcase.chars
  str.select do |char|
    arr << char if str.count(char) > 1
  end

  arr.uniq.count
end

# Examples / Test Cases

p distinct_multiples("xyz") == 0               # (none

# each character only appears once

p distinct_multiples("xxyypzzr") == 3          # x, y, z

# x appears twice, y appears twice, z appears twice; thus 3 is returned

p distinct_multiples("xXyYpzZr") == 3          # x, y, z

# x appears twice, y appears twice, z appears twice; 3 is returned (case insensitive)

p distinct_multiples("unununium") == 2         # u, n

# u appears four times, n appears three times; 2 is returned

p distinct_multiples("multiplicity") == 3      # l, t, i

# l appears twice, t appears twice, i appears twice; 3 is returned

p distinct_multiples("7657") == 1              # 7

# 7 appears twice; 1 is returned

p distinct_multiples("3141592653589793") == 4  # 3, 1, 5, 9

p distinct_multiples("2718281828459045") == 5  # 2, 1, 8, 4, 5

# Problem 17

# Create a method that takes an array of integers as an argument. The method should determine the minimum integer value that can be appended to the array so the sum of all the elements equal the closest prime number that is greater than the current sum of the numbers. For example, the numbers in [1, 2, 3] sum to 6. The nearest prime number greater than 6 is 7. Thus, we can add 1 to the array to sum to 7.

# Notes:

# The array will always contain at least 2 integers.
# All values in the array must be positive (> 0).
# There may be multiple occurrences of the various numbers in the array.

# Understanding the Problem

# inputs: array of integers
# outputs: integer (representing closest prime number greater than array.sum)
# explicit: array will always contain >= 2 integers, all integer elements will be > 0 (positive), same number may occur more than once
# implicit: argument will not be an empty array, sum may or may not already be prime

# Data structure
# Array when working with sums

# Algorithm
# Require prime module
# Get sum of array argument
# Loop through sum += 1
# Break as soon as the sum is prime
# Return sum - arr.sum

# Code

def nearest_prime_sum(arr)
  require "prime"

  sum = arr.sum

  loop do
    sum += 1
    break if sum.prime?
  end

  sum - arr.sum
end

# Examples / Test Cases

p nearest_prime_sum([1, 2, 3]) == 1        # Nearest prime to 6 is 7
p nearest_prime_sum([5, 2]) == 4           # Nearest prime to 7 is 11
p nearest_prime_sum([1, 1, 1]) == 2        # Nearest prime to 3 is 5
p nearest_prime_sum([2, 12, 8, 4, 6]) == 5 # Nearest prime to 32 is 37

# Nearest prime to 163 is 167
p nearest_prime_sum([50, 39, 49, 6, 17, 2]) == 4
