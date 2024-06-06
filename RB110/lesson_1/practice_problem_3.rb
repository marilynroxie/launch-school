[1, 2, 3].reject do |num|
  puts num
end

# puts returns nil, reject "Returns a new Array whose elements are all those from self for which the block returns false or nil" as shown in the docs https://docs.ruby-lang.org/en/3.2/Array.html#method-i-reject Therefore, the return will be [1, 2, 3]
