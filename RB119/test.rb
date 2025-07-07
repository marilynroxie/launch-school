def common_chars(arr)

  # Get unique characters from the first string
  first_string_chars = arr[0].chars.uniq

  result = []

  first_string_chars.each do |char|
    counts = arr.map { |string| string.count(char) }

    min_count = counts.min

    min_count.times { result << char }
  end

  result
end

# Test cases
p common_chars(["bella", "label", "roller"]) == ["e", "l", "l"]
p common_chars(["cool", "lock", "cook"]) == ["c", "o"]
p common_chars(["hello", "goodbye", "booya", "random"]) == ["o"]
p common_chars(%w(aabbaaaa ccdddddd eeffee ggrrrrr yyyzzz)) == []
