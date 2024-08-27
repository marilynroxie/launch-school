def leading_substrings(str)
  str.chars.inject([]) do |substr, char|
    substr << (substr.last.to_s + char)
  end
end

def substrings(str)
  (0...str.length).map { |i| leading_substrings(str[i..-1]) }.flatten
end

p substrings('abcde') == [
  'a', 'ab', 'abc', 'abcd', 'abcde',
  'b', 'bc', 'bcd', 'bcde',
  'c', 'cd', 'cde',
  'd', 'de',
  'e'
]
