[1, 2, 3].any? do |num|
  puts num
  num.odd?
end

# As there is an odd element present, 1, the block returns true since the last line of the block is num.odd? and stops iterating through the elements, only outputting 1 since a true element was found.
# https://docs.ruby-lang.org/en/3.2/Array.html#method-i-any-3F
