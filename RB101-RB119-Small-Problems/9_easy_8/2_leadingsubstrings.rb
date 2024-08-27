def leading_substrings(str)
  str.chars.inject([]) do |substr, char|
    substr << (substr.last.to_s + char)
  end
end

p leading_substrings('abc') == ['a', 'ab', 'abc']
p leading_substrings('a') == ['a']
p leading_substrings('xyzzy') == ['x', 'xy', 'xyz', 'xyzz', 'xyzzy']
