# Courtesy of stephensl
# https://gist.github.com/stephensl/05982181ff92990e9e4d9611d352d3bc

# 1. (part 1, first problem)

=begin
Given non empty string check if it can be constructed by taking a substring of it an appending multiple copies of substring together. Assume given string consists of lowercase English letters only.
Example 1:
Input: 'abab'
Output: true
Explanation: It's the substring 'ab' twice.
Example 2:
Input: 'aba'
Output: false
Explanation: String cannot be constructed from repeating substring.
=end

# Problem 1 - My Solution

def repeated_substring_pattern(str)
  (1..str.length / 2).each do |length|
    substring = str[0, length]

    repeats = str.length / length

    return true if substring * repeats == str
  end

  false
end

p repeated_substring_pattern("abab") == true
p repeated_substring_pattern("aba") == false
p repeated_substring_pattern("aabaaba") == false
p repeated_substring_pattern("abaababaab") == true
p repeated_substring_pattern("abcabcabcabc") == true

# 2. (part 1, second problem)

=begin
Given array of strings made only of lowercase letters, return array of all characters that show up in all strings within the given array (including duplicates) For example, if a character occurs 3 times in all strings, but not 4 times, you need to include that character three times in the final answer.
=end

# Problem 2 - My Solution

p common_chars(["bella", "label", "roller"]) == ["e", "l", "l"]
p common_chars(["cool", "lock", "cook"]) == ["c", "o"]
p common_chars(["hello", "goodbye", "booya", "random"]) == ["o"]
p common_chars(%w(aabbaaaa ccdddddd eeffee ggrrrrr yyyzzz)) == []

# 3. (part 2)

=begin
You have to create a method that takes a positive integer number and returns the next bigger number formed by the same digits.
examples:
12 --> 21
513 --> 531
2017 --> 2071
If no bigger number can be formed using these digits, return -1.
examples:
9 --> -1
111 --> -1
531 --> -1
=end

# Problem 3 - My Solution

p next_bigger_num(9) == -1
p next_bigger_num(12) == 21
p next_bigger_num(513) == 531
p next_bigger_num(2017) == 2071
p next_bigger_num(111) == -1
p next_bigger_num(531) == -1
p next_bigger_num(123456789) == 123456798

# 4. (part 4, first problem)

=begin
The maximum sum subarray problem consists in finding the maximum sum of a contiguous subsequence of an array of integers.
Easy case is when input array is all positive, then return total sum of array.
If total array is made up of only negative numbers, return 0 instead.
Empty array assumed to have 0 greatest sum. Note the empty array is also a valid subarray.
=end

# Problem 4 - My Solution

p max_sequence([-2, 1, -3, 4, -1, 2, 1, -5, 4]) == 6
p max_sequence([]) == 0
p max_sequence([11]) == 11
p max_sequence([-32]) == 0
p max_sequence([-2, 1, -7, 4, -10, 2, 1, 5, 4]) == 12

# 5. (part 3, second problem)

=begin
Write a method to find the longest common prefix string amongst an array of strings
If no common prefix, return empty string.
All given inputs are in lowercase letters a-z.
=end

# Problem 5 - My Solution

def common_prefix(arr)
  prefix = arr[0]

  arr.each do |word|
    while word.index(prefix) != 0
      prefix = prefix.chop
      break if prefix.empty?
    end
  end

  prefix
end

p common_prefix(%w(flower, flow, flight)) == "fl"
p common_prefix(%w(dog racecar car)) == ""
p common_prefix(%w(interspecies interstellar interstate)) == "inters"
p common_prefix(%w(throne dungeon)) == ""
p common_prefix(%w(throne throne)) == "throne"

# 6. (part 4, first problem)

=begin
Given 2 strings, find out if there is a substring that appears in both strings. Return true if you find a substring that appears in both strings, or false if not. Only consider substrings that are longer than one letter long.
=end

# Problem 6 - My Solution

p substr_test("Something", "Fun") == false
p substr_test("Something", "Home") == true
p substr_test("Something", "") == false
p substr_test("", "Something") == false
p substr_test("Banana", "banana") == true
p substr_test("test", "lllt") == false
p substr_test("", "") == false
p substr_test("1234567", "541256") == true
p substr_test("supercalifragilisticexpialidocious", "SoundOfItIsAtrociou") == true

# 7. (part 4, second problem)

=begin
Write a function scramble(str1, str2) that returns true if a portion of str1 characters can be rearranged to match str2, otherwise return false.
For example:
str1 is 'rkqodlw' and str2 is 'world' the output should return true
=end

# Problem 7 - My Solution

def scramble(string, substring)
  frequencies1 = Hash.new(0)
  frequencies2 = Hash.new(0)

  string.each_char do |char|
    frequencies1[char] += 1
  end

  substring.each_char do |char|
    frequencies2[char] += 1
  end

  frequencies2.all? { |char, count| frequencies1[char] >= count }
end

p scramble("javaass", "jjss") == false
p scramble("rkqodlw", "world") == true
p scramble("cedewaraaossoqqty", "codewars") == true
p scramble("katas", "steak") == false
p scramble("scriptjava", "javascript") == true
p scramble("scriptingjava", "javascript") == true

# 8. (part 5)

=begin
Find length of the longest substring in the given string that is the same in reverse.
As an example, if the input ws "I like racecars that go fast", the substring ('racecar') length would be 7.
If the length of the input string is 0, return value must be 0.
=end

# Problem 8 - My Solution

def longest_palindrome(str)
end

p longest_palindrome("a") == 1
p longest_palindrome("aa") == 2
p longest_palindrome("baa") == 2
p longest_palindrome("aab") == 2
p longest_palindrome("baabcd") == 4
p longest_palindrome("baablkj12345432133d") == 9

# 9. (part 6)

=begin
You are going to be given an array of integers. Your job is to take that array and find an index N where the sum of the integers to the left of N is equal to the sum of the integers to the right of N. If there is no index that would make this happen, return -1.
For example:
Let's say you are given the array [1,2,3,4,3,2,1]: Your function will return the index 3, because at the 3rd position of the array, the sum of left side of the index ({1,2,3}) and the sum of the right side of the index ([3,2,1]) both equal 6.
Another one:
You are given the array [20,10,-80,10,10,15,35]
At index 0 the left side is []
The right side is [10,-80,10,10,15,35]
They both are equal to 0 when added. (Empty arrays are equal to 0 in this problem)
Index 0 is the place where the left side and right side are equal.
=end

# Problem 9 - My Solution

p find_even_index([1, 2, 3, 4, 3, 2, 1]) == 3
p find_even_index([1, 100, 50, -51, 1, 1]) == 1
p find_even_index([1, 2, 3, 4, 5, 6]) == -1
p find_even_index([20, 10, 30, 10, 10, 15, 35]) == 3
p find_even_index([20, 10, -80, 10, 10, 15, 35]) == 0
p find_even_index([10, -80, 10, 10, 15, 35, 20]) == 6
p find_even_index(Array(1..100)) == -1
p find_even_index([0, 0, 0, 0, 0]) == 0
p find_even_index([-1, -2, -3, -4, -3, -2, -1]) == 3
p find_even_index(Array(-100..-1)) == -1
